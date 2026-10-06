import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../../domain/repositories/fortress_supplication_repository.dart';

class FortressSupplicationState extends ChangeNotifier {
  FortressSupplicationState(this._supplicationRepository);

  final FortressSupplicationRepository _supplicationRepository;

  final Map<int, FortressSupplicationEntity> _supplicationByIdMap = {};
  final Map<int, List<FortressSupplicationEntity>> _supplicationsByChapterMap = {};
  bool _isLoading = false;
  Object? _error;

  bool get isLoading => _isLoading;

  Object? get error => _error;

  FortressSupplicationEntity? cachedSupplicationById(int supplicationId) => _supplicationByIdMap[supplicationId];

  List<FortressSupplicationEntity>? cachedSupplicationsByChapter(int chapterId) => _supplicationsByChapterMap[chapterId];

  Future<FortressSupplicationEntity?> loadSupplicationById(int supplicationId) async {
    return _supplicationByIdMap[supplicationId] ??
        await _fetch(() async {
          return _supplicationByIdMap[supplicationId] = await _supplicationRepository.fetchSupplicationById(supplicationId: supplicationId);
        });
  }

  Future<List<FortressSupplicationEntity>?> loadSupplicationsByChapter(int chapterId,) async {
    return _supplicationsByChapterMap[chapterId] ??
        await _fetch(() async {
          final supplications = List<FortressSupplicationEntity>.unmodifiable(
            await _supplicationRepository.fetchSupplicationsByChapter(
              chapterId: chapterId,
            ),
          );
          for (final s in supplications) {
            _supplicationByIdMap[s.supplicationId] = s;
          }
          return _supplicationsByChapterMap[chapterId] = supplications;
        });
  }

  Future<T?> _fetch<T>(Future<T> Function() request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      return await request();
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