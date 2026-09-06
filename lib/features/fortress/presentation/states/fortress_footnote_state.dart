import 'package:flutter/foundation.dart';

import '../../domain/entities/fortress_footnote_entity.dart';
import '../../domain/repositories/fortress_footnote_repository.dart';

class FortressFootnoteState extends ChangeNotifier {
  FortressFootnoteState(this._footnoteRepository);

  final FortressFootnoteRepository _footnoteRepository;

  final Map<int, FortressFootnoteEntity> _footnoteByIdMap = {};
  final Map<int, Object> _errorByIdMap = {};
  final Set<int> _loadingIds = {};
  final Map<int, Future<void>> _inFlightRequests = {};

  FortressFootnoteEntity? footnoteById(int footnoteId) => _footnoteByIdMap[footnoteId];

  bool isLoading(int footnoteId) => _loadingIds.contains(footnoteId);

  Object? errorFor(int footnoteId) => _errorByIdMap[footnoteId];

  bool hasError(int footnoteId) => _errorByIdMap.containsKey(footnoteId);

  Future<FortressFootnoteEntity?> loadFootnote(int footnoteId) async {
    final cached = _footnoteByIdMap[footnoteId];
    if (cached != null) return cached;

    final inFlight = _inFlightRequests[footnoteId];
    if (inFlight != null) {
      await inFlight;
      return _footnoteByIdMap[footnoteId];
    }

    final future = _fetchFootnote(footnoteId);
    _inFlightRequests[footnoteId] = future;
    await future;
    _inFlightRequests.remove(footnoteId);

    return _footnoteByIdMap[footnoteId];
  }

  Future<void> _fetchFootnote(int footnoteId) async {
    _loadingIds.add(footnoteId);
    _errorByIdMap.remove(footnoteId);
    notifyListeners();

    try {
      final footnote = await _footnoteRepository.fetchFootnoteById(footnoteId: footnoteId);
      _footnoteByIdMap[footnoteId] = footnote;
    } catch (e) {
      _errorByIdMap[footnoteId] = e;
      debugPrint('Error loading fortress footnote $footnoteId: $e');
    } finally {
      _loadingIds.remove(footnoteId);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _footnoteByIdMap.clear();
    _errorByIdMap.clear();
    _loadingIds.clear();
    _inFlightRequests.clear();
    super.dispose();
  }
}