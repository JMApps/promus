import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'features/main/pages/root_page.dart';
import 'features/main/state/main_state.dart';
import 'features/prayer/state/prayer_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await Hive.openBox(AppConstants.keySettingsPrayerTimeBox);

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
      ],
      child: const RootPage(),
    ),
  );
}
