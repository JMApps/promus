import 'package:flutter/foundation.dart';

import '../../domain/entities/fortress_supplication_entity.dart';
import '../../domain/repositories/fortress_supplication_repository.dart';

class FortressSupplicationState extends ChangeNotifier {
  FortressSupplicationState(this._supplicationRepository);

  final FortressSupplicationRepository _supplicationRepository;

  final Map<int, FortressSupplicationEntity> _supplicationByIdMap = {};
  final Map<int, Object> _errorByIdMap = {};
  final Set<int> _loadingIds = {};
  final Map<int, Future<void>> _inFlightRequestsById = {};

  final Map<int, List<FortressSupplicationEntity>> _supplicationsByChapterMap = {};
  final Map<int, Object> _errorByChapterMap = {};
  final Set<int> _loadingChapters = {};
  final Map<int, Future<void>> _inFlightRequestsByChapter = {};

  FortressSupplicationEntity? supplicationById(int supplicationId) => _supplicationByIdMap[supplicationId];

  bool isLoadingSupplication(int supplicationId) => _loadingIds.contains(supplicationId);

  Object? errorForSupplication(int supplicationId) => _errorByIdMap[supplicationId];

  bool hasErrorForSupplication(int supplicationId) => _errorByIdMap.containsKey(supplicationId);

  List<FortressSupplicationEntity>? supplicationsByChapter(int chapterId) => _supplicationsByChapterMap[chapterId];

  bool isLoadingChapter(int chapterId) => _loadingChapters.contains(chapterId);

  Object? errorForChapter(int chapterId) => _errorByChapterMap[chapterId];

  bool hasErrorForChapter(int chapterId) => _errorByChapterMap.containsKey(chapterId);

  Future<FortressSupplicationEntity?> loadSupplication(int supplicationId) async {
    final cached = _supplicationByIdMap[supplicationId];
    if (cached != null) return cached;

    final inFlight = _inFlightRequestsById[supplicationId];
    if (inFlight != null) {
      await inFlight;
      return _supplicationByIdMap[supplicationId];
    }

    final future = _fetchSupplicationById(supplicationId);
    _inFlightRequestsById[supplicationId] = future;
    await future;
    _inFlightRequestsById.remove(supplicationId);

    return _supplicationByIdMap[supplicationId];
  }

  Future<void> _fetchSupplicationById(int supplicationId) async {
    _loadingIds.add(supplicationId);
    _errorByIdMap.remove(supplicationId);
    notifyListeners();

    try {
      final supplication = await _supplicationRepository.fetchSupplicationById(
        supplicationId: supplicationId,
      );
      _supplicationByIdMap[supplicationId] = supplication;
    } catch (e) {
      _errorByIdMap[supplicationId] = e;
      debugPrint('Error loading fortress supplication $supplicationId: $e');
    } finally {
      _loadingIds.remove(supplicationId);
      notifyListeners();
    }
  }

  Future<List<FortressSupplicationEntity>?> loadSupplicationsByChapter(int chapterId) async {
    final cached = _supplicationsByChapterMap[chapterId];
    if (cached != null) return cached;

    final inFlight = _inFlightRequestsByChapter[chapterId];
    if (inFlight != null) {
      await inFlight;
      return _supplicationsByChapterMap[chapterId];
    }

    final future = _fetchSupplicationsByChapter(chapterId);
    _inFlightRequestsByChapter[chapterId] = future;
    await future;
    _inFlightRequestsByChapter.remove(chapterId);

    return _supplicationsByChapterMap[chapterId];
  }

  Future<void> _fetchSupplicationsByChapter(int chapterId) async {
    _loadingChapters.add(chapterId);
    _errorByChapterMap.remove(chapterId);
    notifyListeners();

    try {
      final supplications = await _supplicationRepository.fetchSupplicationsByChapter(
        chapterId: chapterId,
      );
      _supplicationsByChapterMap[chapterId] = supplications;
      for (final supplication in supplications) {
        _supplicationByIdMap[supplication.supplicationId] = supplication;
      }
    } catch (e) {
      _errorByChapterMap[chapterId] = e;
      debugPrint('Error loading fortress supplications for chapter $chapterId: $e');
    } finally {
      _loadingChapters.remove(chapterId);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _supplicationByIdMap.clear();
    _errorByIdMap.clear();
    _loadingIds.clear();
    _inFlightRequestsById.clear();

    _supplicationsByChapterMap.clear();
    _errorByChapterMap.clear();
    _loadingChapters.clear();
    _inFlightRequestsByChapter.clear();

    super.dispose();
  }
}