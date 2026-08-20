import 'package:flutter/material.dart';

import '../../../../../core/constants/app_device_locales.dart';
import '../../../settings/states/locale_settings_state.dart';
import '../../domain/entities/mushaf_page_row_entity.dart';
import '../../domain/repositories/mushaf_page_repository.dart';
import 'mushaf_page_load_state.dart';

class MushafPageRowState extends ChangeNotifier {
  MushafPageRowState({
    required this._pageRepository,
    required LocaleSettingsState localeSettings,
  }) : _localeSettingsState = localeSettings {
    _lastTranslationColumn = translationColumn;
    _localeSettingsState.addListener(_onTranslationChanged);
  }

  int _loadGeneration = 0;

  final MushafPageRepository _pageRepository;
  final LocaleSettingsState _localeSettingsState;

  final Map<int, MushafPageLoadState> _pages = {};
  final Map<int, Future<void>> _runningLoads = {};

  Set<int> _activeWindow = const {};
  String? _lastTranslationColumn;

  MushafPageLoadState getPageState(int page) {
    return _pages[page] ?? const MushafPageLoadState.initial();
  }

  List<MushafPageRowEntity>? getPageData(int page) {
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

  String get translationColumn {
    final index = _localeSettingsState.translationNameIndex;
    return AppDeviceLocales.ayahTranslations[index].column;
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
    final generation = _loadGeneration;

    _pages[page] = const MushafPageLoadState.loading();
    notifyListeners();

    try {
      final translation = translationColumn;

      final data = await _pageRepository.fetchMushafPageData(
        pageNumber: page,
        translationColumn: translation,
      );

      if (generation != _loadGeneration) return;
      if (!_activeWindow.contains(page)) return;

      _pages[page] = MushafPageLoadState.loaded(data);
    } catch (e) {
      if (generation != _loadGeneration) return;

      if (_activeWindow.contains(page)) {
        _pages[page] = MushafPageLoadState.error(e);
      }
    } finally {
      _runningLoads.remove(page);

      if (generation == _loadGeneration && _activeWindow.contains(page)) {
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
    return page >= 1 && page <= 604;
  }

  void _onTranslationChanged() {
    final current = translationColumn;

    if (_lastTranslationColumn == current) return;

    _lastTranslationColumn = current;
    _reloadActiveWindow();
  }

  Future<void> _reloadActiveWindow() async {
    final pages = _activeWindow.toList();

    _loadGeneration++;

    _pages.clear();
    _runningLoads.clear();

    notifyListeners();

    for (final page in pages) {
      loadPage(page);
    }
  }

  void clear() {
    _pages.clear();
    _runningLoads.clear();
    _activeWindow = const {};
    notifyListeners();
  }

  @override
  void dispose() {
    _localeSettingsState.removeListener(_onTranslationChanged);
    super.dispose();
  }
}
