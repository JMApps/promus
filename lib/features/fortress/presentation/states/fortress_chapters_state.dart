import 'package:flutter/foundation.dart';

import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/repositories/fortress_chapter_repository.dart';

class FortressChapterState extends ChangeNotifier {
  FortressChapterState(this._chapterRepository) {
    _loadAllChapters();
  }

  static const int expectedChaptersCount = 133;

  final FortressChapterRepository _chapterRepository;

  List<FortressChapterEntity> _chapters = const [];
  Map<int, FortressChapterEntity> _chapterByIdMap = const {};

  bool _isLoading = false;
  Object? _error;
  StackTrace? _stackTrace;

  List<FortressChapterEntity> get chapters => _chapters;
  bool get isLoading => _isLoading;
  Object? get error => _error;
  StackTrace? get stackTrace => _stackTrace;
  bool get hasError => _error != null;
  bool get isReady => _chapters.isNotEmpty && !_isLoading;
  int get totalChapters => _chapters.length;

  FortressChapterEntity? chapterById(int chapterId) => _chapterByIdMap[chapterId];

  FortressChapterEntity? chapterByIndex(int index) {
    if (index < 0 || index >= _chapters.length) return null;
    return _chapters[index];
  }

  Future<void> reload() => _loadAllChapters(force: true);

  Future<void> _loadAllChapters({bool force = false}) async {
    if (!force && _chapters.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    _stackTrace = null;
    notifyListeners();

    try {
      final loaded = await _chapterRepository.fetchAllChapters();

      if (loaded.isEmpty) {
        throw StateError('Fortress chapters list is empty');
      }
      if (loaded.length != expectedChaptersCount) {
        debugPrint(
          'Warning: expected $expectedChaptersCount chapters, got ${loaded.length}',
        );
      }

      _chapters = List.unmodifiable(loaded);
      _chapterByIdMap = Map.unmodifiable({
        for (final chapter in _chapters) chapter.chapterId: chapter,
      });
    } catch (e, s) {
      _error = e;
      _stackTrace = s;
      debugPrint('Error loading fortress chapters: $e\n$s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _chapters = const [];
    _chapterByIdMap = const {};
    super.dispose();
  }
}