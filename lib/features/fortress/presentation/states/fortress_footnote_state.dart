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

  final Map<int, List<FortressFootnoteEntity>> _footnotesBySupplicationMap = {};
  final Map<int, Object> _errorBySupplicationMap = {};
  final Set<int> _loadingSupplications = {};
  final Map<int, Future<void>> _inFlightRequestsBySupplication = {};

  FortressFootnoteEntity? footnoteById(int footnoteId) => _footnoteByIdMap[footnoteId];

  bool isLoading(int footnoteId) => _loadingIds.contains(footnoteId);

  Object? errorFor(int footnoteId) => _errorByIdMap[footnoteId];

  bool hasError(int footnoteId) => _errorByIdMap.containsKey(footnoteId);

  List<FortressFootnoteEntity>? footnotesBySupplication(int supplicationId) => _footnotesBySupplicationMap[supplicationId];

  bool isLoadingSupplication(int supplicationId) => _loadingSupplications.contains(supplicationId);

  Object? errorForSupplication(int supplicationId) => _errorBySupplicationMap[supplicationId];

  bool hasErrorForSupplication(int supplicationId) => _errorBySupplicationMap.containsKey(supplicationId);

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

  Future<List<FortressFootnoteEntity>?> loadFootnotesBySupplication(int supplicationId) async {
    final cached = _footnotesBySupplicationMap[supplicationId];
    if (cached != null) return cached;

    final inFlight = _inFlightRequestsBySupplication[supplicationId];
    if (inFlight != null) {
      await inFlight;
      return _footnotesBySupplicationMap[supplicationId];
    }

    final future = _fetchFootnotesBySupplication(supplicationId);
    _inFlightRequestsBySupplication[supplicationId] = future;
    await future;
    _inFlightRequestsBySupplication.remove(supplicationId);

    return _footnotesBySupplicationMap[supplicationId];
  }

  Future<void> _fetchFootnotesBySupplication(int supplicationId) async {
    _loadingSupplications.add(supplicationId);
    _errorBySupplicationMap.remove(supplicationId);
    notifyListeners();

    try {
      final footnotes = await _footnoteRepository.fetchFootnotesBySupplication(
        supplicationId: supplicationId,
      );
      _footnotesBySupplicationMap[supplicationId] = footnotes;
      for (final footnote in footnotes) {
        _footnoteByIdMap[footnote.footnoteId] = footnote;
      }
    } catch (e) {
      _errorBySupplicationMap[supplicationId] = e;
      debugPrint('Error loading fortress footnotes for supplication $supplicationId: $e');
    } finally {
      _loadingSupplications.remove(supplicationId);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _footnoteByIdMap.clear();
    _errorByIdMap.clear();
    _loadingIds.clear();
    _inFlightRequests.clear();

    _footnotesBySupplicationMap.clear();
    _errorBySupplicationMap.clear();
    _loadingSupplications.clear();
    _inFlightRequestsBySupplication.clear();

    super.dispose();
  }
}