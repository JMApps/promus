import 'package:flutter/material.dart';
import 'package:promus/features/fortress/data/arguments/fortress_chapter_args.dart';
import 'package:promus/features/fortress/presentation/pages/fortress_supplications_page.dart';

import '../../features/quran/reader/data/args/reader_args.dart';
import '../../features/quran/reader/presentation/pages/reader_page.dart';
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
    NamesRouter.pageReader: (context, args) {
      final ReaderArgs readerArgs = ReaderArgs(pageNumber: args.pageNumber);
      return ReaderPage(initialPage: readerArgs.pageNumber);
    },
    NamesRouter.fortressSupplicationsPage: (context, args) {
      final FortressChapterArgs fortressChapterArgs = FortressChapterArgs(args);
      return FortressSupplicationsPage(chapterModel: fortressChapterArgs.chapterEntity);
    },
  };
}
