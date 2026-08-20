import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// Управляет загрузкой per-page TTF шрифтов (assets/pageFonts/pN.ttf).
///
/// Важно: Flutter (dart:ui FontLoader) не предоставляет API для выгрузки
/// уже зарегистрированного шрифта из движка — однажды загруженный шрифт
/// остаётся в font manager до конца жизни приложения. Поэтому "держать
/// только 3 в памяти" реализовано на уровне логики (не грузим то, что вне
/// окна, и не грузим повторно уже загруженное), а не как физическая
/// выгрузка байтов из движка. Сами байты ttf-файла после вызова
/// FontLoader.load() не удерживаются этим классом.
class MushafPageFontState extends ChangeNotifier {
  final Set<int> _loadedPages = {};
  final Map<int, Future<void>> _runningLoads = {};

  Set<int> _activeWindow = const {};

  static String fontFamilyForPage(int page) => 'MushafPage$page';

  bool isPageFontLoaded(int page) => _loadedPages.contains(page);

  bool isPageFontLoading(int page) => _runningLoads.containsKey(page);

  String? getFontFamily(int page) {
    return isPageFontLoaded(page) ? fontFamilyForPage(page) : null;
  }

  Future<void> loadPage(int page) {
    if (!_isValidPage(page)) {
      return Future.value();
    }

    if (isPageFontLoaded(page)) {
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
    try {
      final family = fontFamilyForPage(page);
      final loader = FontLoader(family)
        ..addFont(
          rootBundle.load('assets/pageFonts/p$page.ttf'),
        );

      await loader.load();

      if (!_activeWindow.contains(page)) return;

      _loadedPages.add(page);
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
}
