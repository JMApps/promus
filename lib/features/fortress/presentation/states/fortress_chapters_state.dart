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
    } catch (e, s) {
      _error = e;
      debugPrint('${AppStrings.errorLoadData}: $e\n$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
