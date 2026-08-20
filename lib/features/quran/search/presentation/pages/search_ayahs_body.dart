import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ayahs/domain/entities/ayah_by_ayah_entity.dart';
import '../../../ayahs/presentation/states/ayah_by_ayah_state.dart';
import '../lists/ayah_search_list.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_error.dart';
import '../widgets/search_result_header.dart';

class SearchAyahsBody extends StatelessWidget {
  const SearchAyahsBody({
    super.key,
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return const SearchEmptyState(
        message: 'Введите запрос для поиска',
      );
    }

    return FutureBuilder<List<AyahByAyahEntity>>(
      future: context.read<AyahByAyahState>().searchAyahs(
        query: trimmedQuery,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (snapshot.hasError) {
          return SearchErrorWidget(
            error: snapshot.error,
            onRetry: () {},
          );
        }

        final results = snapshot.data ?? const <AyahByAyahEntity>[];

        if (results.isEmpty) {
          return const SearchEmptyState();
        }

        final totalMatches = _countMatches(
          results: results,
          query: trimmedQuery,
        );

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            SearchResultsHeader(
              query: trimmedQuery,
              matchCount: totalMatches,
              resultCount: results.length,
            ),
            // Список результатов
            Expanded(
              child: AyahSearchList(
                searchResultList: results,
                query: trimmedQuery,
              ),
            ),
          ],
        );
      },
    );
  }

  int _countMatches({
    required List<AyahByAyahEntity> results,
    required String query,
  }) {
    if (query.isEmpty) return 0;

    final isArabic = _containsArabic(query);

    int total = 0;
    final regex = RegExp(
      RegExp.escape(query),
      caseSensitive: isArabic,
      unicode: true,
    );

    for (final ayah in results) {
      final text = isArabic ? ayah.ayahArabic : ayah.ayahTranslation;
      total += regex.allMatches(text).length;
    }

    return total;
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
