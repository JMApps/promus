import 'package:flutter/foundation.dart';

import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';

class SurahNameState extends ChangeNotifier {
  SurahNameState(this._surahNameRepository) {
    _loadAllSurahs();
  }

  static const int expectedSurahsCount = 114;

  final SurahNameRepository _surahNameRepository;

  List<SurahNameEntity> _surahs = const [];
  Map<int, SurahNameEntity> _surahByNumberMap = const {};

  bool _isLoading = false;
  Object? _error;
  StackTrace? _stackTrace;

  List<SurahNameEntity> get surahs => _surahs;
  bool get isLoading => _isLoading;
  Object? get error => _error;
  StackTrace? get stackTrace => _stackTrace;
  bool get hasError => _error != null;
  bool get isReady => _surahs.isNotEmpty && !_isLoading;
  int get totalSurahs => _surahs.length;

  SurahNameEntity? surahByNumber({required int surahNumber}) =>
      _surahByNumberMap[surahNumber];

  SurahNameEntity? surahByIndex(int index) {
    if (index < 0 || index >= _surahs.length) return null;
    return _surahs[index];
  }

  String? surahByVerseKey(String surahTitle, String verseKey, String ayahTitle) {
    if (!isReady) return null;

    final parts = verseKey.split(':');
    if (parts.length != 2) return null;

    final surahNumber = int.tryParse(parts[0]);
    if (surahNumber == null) return null;

    final surah = _surahByNumberMap[surahNumber];
    if (surah == null) return null;

    return '$surahTitle ${surah.nameTranscription}, $ayahTitle ${parts[1]}';
  }

  Future<void> reload() => _loadAllSurahs(force: true);

  Future<void> _loadAllSurahs({bool force = false}) async {
    if (!force && _surahs.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    _stackTrace = null;
    notifyListeners();

    try {
      final loaded = await _surahNameRepository.fetchAllSurahs();

      if (loaded.isEmpty) {
        throw StateError('Surahs list is empty');
      }
      if (loaded.length != expectedSurahsCount) {
        debugPrint(
          'Warning: expected $expectedSurahsCount surahs, got ${loaded.length}',
        );
      }

      _surahs = List.unmodifiable(loaded);
      _surahByNumberMap = Map.unmodifiable({
        for (var i = 0; i < _surahs.length; i++) i + 1: _surahs[i],
      });
    } catch (e, s) {
      _error = e;
      _stackTrace = s;
      debugPrint('Error loading surahs: $e\n$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _surahs = const [];
    _surahByNumberMap = const {};
    super.dispose();
  }
}