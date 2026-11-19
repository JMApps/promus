import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../ayahs/states/ayah_by_ayah_state.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../lists/ayahs_search_chapter_list.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_error.dart';
import '../widgets/search_result_header.dart';

/// Результаты поиска аятов.
///
/// Ищет через [debounce] после последнего изменения [query], а не на каждую
/// букву и не на каждую перестройку (клавиатура, тема). Пока пользователь
/// печатает, на экране остаются прошлые результаты.
class SearchAyahsBody extends StatefulWidget {
  const SearchAyahsBody({
    super.key,
    required this.query,
    this.debounce = const Duration(milliseconds: 300),
  });

  final String query;
  final Duration debounce;

  @override
  State<SearchAyahsBody> createState() => _SearchAyahsBodyState();
}

class _SearchAyahsBodyState extends State<SearchAyahsBody> {
  Future<List<AyahByAyahEntity>>? _future;
  String _searchedQuery = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Новый экземпляр (например, buildResults после «Найти») ищет сразу.
    _search(widget.query.trim());
  }

  @override
  void didUpdateWidget(SearchAyahsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final query = widget.query.trim();
    if (query == oldWidget.query.trim()) return;

    _timer?.cancel();
    if (query.isEmpty) {
      _search(query); // очистка — сразу, без задержки
      return;
    }
    _timer = Timer(widget.debounce, () {
      if (mounted) setState(() => _search(query));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _search(String query) {
    _searchedQuery = query;
    _future = query.isEmpty ? null : context.read<AyahByAyahState>().searchAyahs(query: query);
  }

  @override
  Widget build(BuildContext context) {
    final future = _future;
    if (future == null) {
      return const SearchEmptyState(
        message: AppStrings.startSearch,
      );
    }

    return FutureBuilder<List<AyahByAyahEntity>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (snapshot.hasError) {
          return SearchErrorWidget(
            error: snapshot.error,
            onRetry: () => setState(() => _search(_searchedQuery)),
          );
        }

        final results = snapshot.data ?? const <AyahByAyahEntity>[];
        if (results.isEmpty) {
          return const SearchEmptyState();
        }

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            // Число найденных аятов. Подсветку по османскому тексту не считаем:
            // её написание отличается от запроса, и счётчик мог показать
            // «ничего не найдено» при непустом списке.
            SearchResultsHeader(
              query: _searchedQuery,
              matchCount: results.length,
              resultCount: results.length,
            ),
            Expanded(
              child: AyahSearchList(
                searchResultList: results,
                query: _searchedQuery,
              ),
            ),
          ],
        );
      },
    );
  }
}