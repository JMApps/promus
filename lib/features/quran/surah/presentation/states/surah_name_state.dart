import 'package:flutter/material.dart';

import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';

class SurahNameState extends ChangeNotifier {
  SurahNameState(this._surahNameRepository) {
    _loadAllSurahs();
  }

  final SurahNameRepository _surahNameRepository;

  List<SurahNameEntity> _surahs = const [];

  Map<int, SurahNameEntity> _surahByNumberMap = {};

  bool _isLoading = false;
  Object? _error;

  List<SurahNameEntity> get surahs => List.unmodifiable(_surahs);
  bool get isLoading => _isLoading;
  Object? get error => _error;
  bool get isReady => _surahs.isNotEmpty && !_isLoading;
  bool get hasError => _error != null;
  int get totalSurahs => _surahs.length;

  String? surahByVerseKey(String surahTitle, String verseKey, String ayahTitle) {
    if (!isReady) return null;

    final parts = verseKey.split(':');
    if (parts.length != 2) return null;

    final surahNumber = int.tryParse(parts[0]);
    final ayahNumber = parts[1];

    if (surahNumber == null || surahNumber < 1 || surahNumber > 114) {
      return null;
    }

    final surah = _surahByNumberMap[surahNumber];
    if (surah == null) return null;

    return '$surahTitle ${surah.nameTranscriptionRu}, $ayahTitle $ayahNumber';
  }

  SurahNameEntity? surahByNumber({required int surahNumber}) {
    if (surahNumber < 1 || surahNumber > 114) return null;
    return _surahByNumberMap[surahNumber];
  }

  SurahNameEntity? surahByIndex(int index) {
    if (index < 0 || index >= _surahs.length) return null;
    return _surahs[index];
  }

  Future<void> reload() async {
    await _loadAllSurahs(force: true);
  }

  Future<void> _loadAllSurahs({bool force = false}) async {
    if (!force && _surahs.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loadedSurahs = await _surahNameRepository.fetchAllSurahs();
      if (loadedSurahs.isEmpty) {
        throw Exception('Loaded surahs list is empty');
      }
      if (loadedSurahs.length != 114) {
        debugPrint('Warning: Expected 114 surahs, got ${loadedSurahs.length}');
      }
      _surahs = List.unmodifiable(loadedSurahs);
      _buildSurahMap();

    } catch (e, stackTrace) {
      _error = e;
      debugPrint('Error loading surahs: $e\n$stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _buildSurahMap() {
    _surahByNumberMap = {
      for (var i = 0; i < _surahs.length; i++)
        i + 1: _surahs[i],
    };
  }

  @override
  void dispose() {
    _surahByNumberMap.clear();
    super.dispose();
  }
}