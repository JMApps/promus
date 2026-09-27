import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../lists/fortress_search_chapter_list.dart';

class SearchChaptersDelegate extends SearchDelegate<void> {
  SearchChaptersDelegate({required this.chapters}) : super(
    searchFieldLabel: AppStrings.searchByChapters,
    keyboardType: .text,
    textInputAction: .search,
  );

  final List<FortressChapterEntity> chapters;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        titleSpacing: -AppSpacing.small,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: .none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: transitionAnimation,
          ),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      padding: .zero,
      alignment: .center,
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FortressSearchChapterList(
      chapters: chapters,
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FortressSearchChapterList(
      chapters: chapters,
      query: query,
    );
  }
}
