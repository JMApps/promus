import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:promus/features/quran/reader/presentation/states/mushaf_page_font_state.dart';
import 'package:promus/features/quran/settings/states/reading_settings_state.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/database/database_helper.dart';
import 'features/main/pages/root_page.dart';
import 'features/main/state/main_state.dart';
import 'features/prayer/state/prayer_state.dart';
import 'features/quran/surah/data/data_sources/surah_local_data_source_impl.dart';
import 'features/quran/surah/data/repositories/surah_name_repository_impl.dart';
import 'features/quran/surah/presentation/states/surah_name_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await Hive.openBox(AppConstants.keySettingsPrayerTimeBox);
  await Hive.openBox(AppConstants.mainAppSettingsBox);

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

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
          create: (_) => MushafPageFontState(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReadingSettingsState(),
        ),
        ChangeNotifierProvider(
          create: (_) => SurahNameState(SurahNameRepositoryImpl(SurahLocalDataSourceImpl(databaseHelper))),
        ),
      ],
      child: const RootPage(),
    ),
  );
}
