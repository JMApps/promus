import 'package:flutter/material.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../lists/favorite_ayahs_list.dart';
import '../lists/favorite_pages_list.dart';
import '../lists/last_favorite_pages_list.dart';
import '../widgets/clean_bookmarks_button.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'Избранное',
            style: AppTextStyles.medium,
          ),
          actions: const [
            CleanFavoritesButton(),
          ],
          bottom: const TabBar(
            labelStyle: AppTextStyles.medium,
            splashBorderRadius: AppRadius.medium,
            tabs: [
              Tab(text: 'Последнее'),
              Tab(text: 'Страницы'),
              Tab(text: 'Аяты'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LastFavoritePagesList(),
            FavoritePagesList(),
            FavoriteAyahsList(),
          ],
        ),
      ),
    );
  }
}
