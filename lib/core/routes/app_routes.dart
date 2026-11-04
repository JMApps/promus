import 'package:flutter/material.dart';

import '../../features/fortress/presentation/pages/fortress_supplications_page.dart';
import '../../features/main/pages/main_notifications_page.dart';
import '../../features/main/pages/main_settings_page.dart';
import '../../features/prayer/presentation/pages/monthly_prayers_page.dart';
import '../../features/prayer/presentation/pages/prayer_params_page.dart';
import '../../features/prayer/presentation/pages/selection_city_page.dart';
import '../../features/quran/data/args/reader_args.dart';
import '../../features/quran/reader/pages/mushaf_reader_page.dart';
import 'names_router.dart';

class AppRoutes {
  static Route<dynamic> onRouteGenerator(RouteSettings routeSettings) {
    final builder = routes[routeSettings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) {
          return builder(context, routeSettings.arguments);
        },
      );
    }
    throw Exception('Invalid route');
  }

  static Map<String, Widget Function(BuildContext, dynamic)> routes = {
    NamesRouter.mainSettingsPage: (context, args) {
      return const MainSettingsPage();
    },
    NamesRouter.mainNotificationsPage: (context, args) {
      return const MainNotificationsPage();
    },
    NamesRouter.pageReader: (context, args) {
      final ReaderArgs readerArgs = ReaderArgs(
        pageNumber: args.pageNumber,
        verseKey: args.verseKey,
      );
      return MushafReaderPage(
        initialPage: readerArgs.pageNumber,
        initialVerseKey: readerArgs.verseKey,
      );
    },
    NamesRouter.fortressSupplicationsPage: (context, args) {
      final int chapterId = args;
      return FortressSupplicationsPage(
        chapterId: chapterId,
      );
    },
    NamesRouter.selectionCityPage: (context, args) {
      return const SelectionCityPage();
    },
    NamesRouter.prayerParamsPage: (context, args) {
      return const PrayerParamsPage();
    },
    NamesRouter.monthlyPrayersPage: (context, args) {
      return const MonthlyPrayersPage();
    },
  };
}
