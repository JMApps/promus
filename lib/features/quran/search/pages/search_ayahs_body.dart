import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/text_matcher.dart';
import '../../ayahs/states/ayah_by_ayah_state.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../lists/ayahs_search_chapter_list.dart';
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
        message: AppStrings.startSearch,
      );
    }

    return FutureBuilder<List<AyahByAyahEntity>>(
      future: context.read<AyahByAyahState>().searchAyahs(
        query: trimmedQuery,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
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

    final isArabic = TextMatcher.containsArabic(query);

    var total = 0;
    for (final ayah in results) {
      final text = isArabic ? ayah.ayahArabic : ayah.ayahTranslation;
      total += TextMatcher.findRanges(
        text: text,
        query: query,
        isArabic: isArabic,
      ).length;
    }

    return total;
  }
}