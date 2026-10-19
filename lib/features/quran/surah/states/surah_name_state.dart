import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';

class SurahNameState extends ChangeNotifier {
  SurahNameState(this._repository) {
    _load();
  }

  final SurahNameRepository _repository;

  List<SurahNameEntity> _allSurahs = const [];
  Map<int, SurahNameEntity> _byNumber = const {};
  bool _isLoading = true;
  Object? _error;

  List<SurahNameEntity> get allSurahs => _allSurahs;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  SurahNameEntity? surahByNumber({required int surahNumber}) =>
      _byNumber[surahNumber];

  String? surahByVerseKey(String surahTitle, String verseKey, String ayahTitle) {
    final parts = verseKey.split(':');
    if (parts.length != 2) return null;

    final number = int.tryParse(parts[0]);
    final surah = number == null ? null : _byNumber[number];
    if (surah == null) return null;

    return '$surahTitle ${surah.nameTranscription}, $ayahTitle ${parts[1]}';
  }

  Future<void> _load() async {
    try {
      final surahs = await _repository.fetchAllSurahs();
      _allSurahs = List.unmodifiable(surahs);
      _byNumber = {for (final s in surahs) s.surahNumber: s};
    } catch (e, s) {
      _error = e;
      debugPrint('${AppStrings.errorLoadData}: $e\n$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}