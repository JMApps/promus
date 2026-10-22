import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../lists/ayahs_search_chapter_list.dart';

class SearchAyahsDelegate extends SearchDelegate<void> {
  SearchAyahsDelegate({required this.search}) : super(
    searchFieldLabel: AppStrings.searchAyahs,
    keyboardType: .text,
    textInputAction: .search,
  );

  final Future<List<AyahByAyahEntity>> Function(String query) search;

  String? _lastQuery;
  Future<List<AyahByAyahEntity>>? _future;

  Future<List<AyahByAyahEntity>> _resultsFor(String q) {
    if (_lastQuery != q) {
      _lastQuery = q;
      _future = search(q);
    }
    return _future!;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        titleSpacing: -AppSpacing.small,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
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
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _body();

  @override
  Widget buildSuggestions(BuildContext context) => _body();

  Widget _body() {
    final q = query.trim();
    if (q.length < 2) return const SizedBox.shrink();
    return AyahsSearchList(future: _resultsFor(q));
  }
}