import 'package:flutter/foundation.dart';

import '../domain/entities/mushaf_page_meta_entity.dart';
import '../domain/repositories/mushaf_page_meta_repository.dart';

class MushafPageMetaState extends ChangeNotifier {
  MushafPageMetaState(this._pageMetaRepository) {
    loadAllPagesMeta();
  }

  final MushafPageMetaRepository _pageMetaRepository;

  Map<int, MushafPageMetaEntity> _pageMetaById = const {};

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
      final List<MushafPageMetaEntity> result = await _pageMetaRepository.fetchMushafPagesMeta();
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

  MushafPageMetaEntity? metaByPageNumber(int pageNumber) => _pageMetaById[pageNumber];

  List<MushafPageMetaEntity> resolvePages(List<int> pageIds) {
    if (_pageMetaById.isEmpty || pageIds.isEmpty) return const [];

    return List.unmodifiable([
      for (final id in pageIds)
        if (_pageMetaById.containsKey(id)) _pageMetaById[id]!,
    ]);
  }
}