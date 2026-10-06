import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/fortress_footnote_entity.dart';
import '../../domain/repositories/fortress_footnote_repository.dart';

class FortressFootnoteState extends ChangeNotifier {
  FortressFootnoteState(this._footnoteRepository);

  final FortressFootnoteRepository _footnoteRepository;

  final Map<int, FortressFootnoteEntity> _footnoteByIdMap = {};
  final Map<int, List<FortressFootnoteEntity>> _footnotesBySupplicationMap = {};
  bool _isLoading = false;
  Object? _error;

  bool get isLoading => _isLoading;

  Object? get error => _error;

  FortressFootnoteEntity? cachedFootnoteById(int footnoteId) => _footnoteByIdMap[footnoteId];

  List<FortressFootnoteEntity>? cachedFootnotesBySupplication(int supplicationId) => _footnotesBySupplicationMap[supplicationId];

  String? formattedFootnotesText(int supplicationId) {
    final footnotes = _footnotesBySupplicationMap[supplicationId];
    if (footnotes == null || footnotes.isEmpty) return null;
    return footnotes.map((f) => '[${f.footnoteId}] - ${f.footnote}').join('\n');
  }

  Future<FortressFootnoteEntity?> loadFootnoteById(int footnoteId) async {
    final cached = _footnoteByIdMap[footnoteId];
    if (cached != null) return cached;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      return _footnoteByIdMap[footnoteId] = await _footnoteRepository.fetchFootnoteById(footnoteId: footnoteId);
    } catch (e, s) {
      _error = e;
      debugPrint('${AppStrings.errorLoadData}: $e\n$s');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<FortressFootnoteEntity>?> loadFootnotesBySupplication(int supplicationId,) async {
    final cached = _footnotesBySupplicationMap[supplicationId];
    if (cached != null) return cached;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final footnotes = List<FortressFootnoteEntity>.unmodifiable(
        await _footnoteRepository.fetchFootnotesBySupplication(
          supplicationId: supplicationId,
        ),
      );
      for (final footnote in footnotes) {
        _footnoteByIdMap[footnote.footnoteId] = footnote;
      }
      return _footnotesBySupplicationMap[supplicationId] = footnotes;
    } catch (e, s) {
      _error = e;
      debugPrint('${AppStrings.errorLoadData}: $e\n$s');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}