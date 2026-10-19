import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:promus/features/quran/reader/states/reader_app_bar_state.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/database/fortress_database_helper.dart';
import 'core/database/mushaf_database_helper.dart';
import 'features/counter/state/main_counter_state.dart';
import 'features/fortress/data/repositories/fortress_chapter_repository_impl.dart';
import 'features/fortress/data/repositories/fortress_footnote_repository_impl.dart';
import 'features/fortress/data/repositories/fortress_supplication_repository_impl.dart';
import 'features/fortress/presentation/states/fortress_chapters_state.dart';
import 'features/fortress/presentation/states/fortress_footnote_state.dart';
import 'features/fortress/presentation/states/fortress_supplications_state.dart';
import 'features/main/pages/root_page.dart';
import 'features/main/state/main_state.dart';
import 'features/prayer/state/prayer_state.dart';
import 'features/quran/data/repositories/page_meta_repository_impl.dart';
import 'features/quran/data/repositories/surah_name_repository_impl.dart';
import 'features/quran/states/mushaf_page_meta_state.dart';
import 'features/quran/states/mushaf_page_number_state.dart';
import 'features/quran/surah/states/surah_name_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await Hive.openBox(AppConstants.keySettingsPrayerTimeBox);
  await Hive.openBox(AppConstants.mainAppSettingsBox);
  await Hive.openBox(AppConstants.keyMainCounterBox);

  final appCounterBox = Hive.box(AppConstants.keyMainCounterBox);

  final FortressDatabaseHelper fortressDatabaseHelper = FortressDatabaseHelper.instance;
  final MushafDatabaseHelper mushafDatabaseHelper = MushafDatabaseHelper.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainState(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              PrayerState(Hive.box(AppConstants.keySettingsPrayerTimeBox)),
        ),
        ChangeNotifierProvider(
          create: (_) => SurahNameState(
            SurahNameRepositoryImpl(mushafDatabaseHelper),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MushafPageNumberState(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReaderAppBarState(),
        ),
        ChangeNotifierProvider(
          create: (_) => MushafPageMetaState(
            MushafPageMetaRepositoryImpl(mushafDatabaseHelper),
          ),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => FortressChapterState(
            FortressChapterRepositoryImpl(fortressDatabaseHelper),
          ),
        ),
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => FortressSupplicationState(
            FortressSupplicationRepositoryImpl(fortressDatabaseHelper),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FortressFootnoteState(
            FortressFootnoteRepositoryImpl(fortressDatabaseHelper),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MainCounterState(box: appCounterBox),
        ),
      ],
      child: const RootPage(),
    ),
  );
}
