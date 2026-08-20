import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../pages/search_ayahs_body.dart';

class SearchAyahsDelegate extends SearchDelegate<void> {
  SearchAyahsDelegate({required this.searchField})
    : super(
        searchFieldLabel: searchField,
        keyboardType: .text,
        textInputAction: .search,
      );

  final String searchField;

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
    return SearchAyahsBody(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchAyahsBody(
      query: query,
    );
  }
}
