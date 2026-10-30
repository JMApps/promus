import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/repositories/fortress_chapter_repository.dart';

class FortressChapterState extends ChangeNotifier {
  FortressChapterState(this._fortressRepository) {
    _loadAllChapters();
  }

  final FortressChapterRepository _fortressRepository;

  List<FortressChapterEntity> _fortressChapters = const [];
  List<String> _index = const [];
  bool _isLoading = true;
  Object? _error;

  List<FortressChapterEntity> get fortressChapters => _fortressChapters;

  bool get isLoading => _isLoading;

  Object? get error => _error;

  Future<void> _loadAllChapters() async {
    try {
      _fortressChapters = List.unmodifiable(
        await _fortressRepository.fetchAllChapters(),
      );
      _index = [
        for (final c in _fortressChapters)
          '${c.chapterId} ${c.chapterTitle}'.toLowerCase(),
      ];
    } catch (e, s) {
      _error = e;
      debugPrint('${AppStrings.errorLoadData}: $e\n$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<FortressChapterEntity> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return _fortressChapters;
    return [
      for (var i = 0; i < _fortressChapters.length; i++)
        if (_index[i].contains(q)) _fortressChapters[i],
    ];
  }
}