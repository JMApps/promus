import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';

class SurahNameState extends ChangeNotifier {
  SurahNameState(this._surahNameRepository) {
    _loadAllSurahs();
  }

  final SurahNameRepository _surahNameRepository;

  List<SurahNameEntity> _allSurahs = const [];
  bool _isLoading = true;
  Object? _error;

  List<SurahNameEntity> get allSurahs => _allSurahs;

  bool get isLoading => _isLoading;

  Object? get error => _error;

  SurahNameEntity? surahByNumber({required int surahNumber}) {
    return _allSurahs[surahNumber];
  }

  Future<void> _loadAllSurahs() async {
    try {
      _allSurahs = .unmodifiable(await _surahNameRepository.fetchAllSurahs());
    } catch (e, s) {
      _error = e;
      debugPrint('${AppStrings.errorLoadData}: $e\n$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
