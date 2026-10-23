import 'package:flutter/material.dart';

import '../../../core/constants/app_constant_keys.dart';
import '../../../core/database/constants/column_names.dart';
import '../domain/entities/mushaf_page_entity.dart';
import '../domain/repositories/mushaf_page_repository.dart';
import 'mushaf_page_load_state.dart';

class MushafPageState extends ChangeNotifier {

  MushafPageState(this._pageRepository);

  final MushafPageRepository _pageRepository;

  final Map<int, MushafPageLoadState> _pages = {};
  final Map<int, Future<void>> _runningLoads = {};

  Set<int> _activeWindow = const {};

  MushafPageLoadState getPageState(int page) {
    return _pages[page] ?? const MushafPageLoadState.initial();
  }

  List<MushafPageEntity>? getPageData(int page) {
    return _pages[page]?.data;
  }

  bool isPageLoaded(int page) {
    return _pages[page]?.loaded ?? false;
  }

  bool isPageLoading(int page) {
    return _pages[page]?.loading ?? false;
  }

  Object? getPageError(int page) {
    return _pages[page]?.error;
  }

  Future<void> loadPage(int page) {
    if (!_isValidPage(page)) {
      return Future.value();
    }

    if (isPageLoaded(page)) {
      return Future.value();
    }

    final running = _runningLoads[page];
    if (running != null) {
      return running;
    }

    final future = _loadPageInternal(page);
    _runningLoads[page] = future;

    return future;
  }

  Future<void> _loadPageInternal(int page) async {
    _pages[page] = const MushafPageLoadState.loading();
    notifyListeners();

    try {

      final data = await _pageRepository.fetchMushafPageData(
        pageNumber: page,
        translationColumn: ColumnNames.ayahRuKuliev,
      );

      if (!_activeWindow.contains(page)) return;

      _pages[page] = MushafPageLoadState.loaded(data);
    } catch (e) {
      if (_activeWindow.contains(page)) {
        _pages[page] = MushafPageLoadState.error(e);
      }
    } finally {
      _runningLoads.remove(page);

      if (_activeWindow.contains(page)) {
        notifyListeners();
      }
    }
  }

  void loadWindow(int page) {
    if (!_isValidPage(page)) return;

    final pages = _buildWindow(page);

    _activeWindow = pages;

    _pages.removeWhere((pageNumber, _) {
      return !pages.contains(pageNumber);
    });

    _runningLoads.removeWhere((pageNumber, _) {
      return !pages.contains(pageNumber);
    });

    notifyListeners();

    for (final pageNumber in pages) {
      loadPage(pageNumber);
    }
  }

  Set<int> _buildWindow(int page) {
    final previous = page - 1;
    final next = page + 1;

    return <int>{
      if (_isValidPage(previous)) previous,
      if (_isValidPage(page)) page,
      if (_isValidPage(next)) next,
    };
  }

  bool _isValidPage(int page) {
    return page >= 1 && page <= AppConstantKeys.totalMushafPageCount;
  }

  void clear() {
    _pages.clear();
    _runningLoads.clear();
    _activeWindow = const {};
    notifyListeners();
  }
}
