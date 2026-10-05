import 'package:flutter/foundation.dart';

import '../domain/entities/page_meta_entity.dart';
import '../domain/repositories/page_meta_repository.dart';

class PageMetaState extends ChangeNotifier {
  PageMetaState(this._pageMetaRepository) {
    loadAllPagesMeta();
  }

  final PageMetaRepository _pageMetaRepository;

  Map<int, PageMetaEntity> _pageMetaById = const {};

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  bool get isLoading => _isLoading;
  Object? get error => _error;

  bool _translationEnabled = false;

  bool get translationEnabled => _translationEnabled;

  set translationEnabled(bool state) {
    _translationEnabled = state;
    notifyListeners();
  }

  Future<void> loadAllPagesMeta() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;

    try {
      final List<PageMetaEntity> result = await _pageMetaRepository.fetchAppPagesMeta();
      _pageMetaById = {
        for (final item in result) item.pageNumber: item,
      };
      _isLoaded = true;
    } catch (e) {
      _error = e;
      _isLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  PageMetaEntity? metaByPageNumber(int pageNumber) => _pageMetaById[pageNumber];

  List<PageMetaEntity> resolvePages(List<int> pageIds) {
    if (_pageMetaById.isEmpty || pageIds.isEmpty) return const [];

    return List.unmodifiable([
      for (final id in pageIds)
        if (_pageMetaById.containsKey(id)) _pageMetaById[id]!,
    ]);
  }
}