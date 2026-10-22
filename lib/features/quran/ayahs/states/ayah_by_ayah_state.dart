import 'package:flutter/foundation.dart';

import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';

class AyahByAyahState extends ChangeNotifier {
  AyahByAyahState(this._ayahByAyahRepository);

  final AyahByAyahRepository _ayahByAyahRepository;

  List<AyahByAyahEntity> _favoriteAyahs = const [];
  bool _isFavoritesLoading = false;
  Object? _favoritesError;

  List<AyahByAyahEntity> get favoriteAyahs => _favoriteAyahs;

  bool get isFavoritesLoading => _isFavoritesLoading;

  Object? get favoritesError => _favoritesError;

  Future<void> loadFavoriteAyahs(List<int> ayahIds) async {
    if (ayahIds.isEmpty) {
      _favoriteAyahs = const [];
      _favoritesError = null;
      _isFavoritesLoading = false;
      notifyListeners();
      return;
    }

    _isFavoritesLoading = true;
    _favoritesError = null;
    notifyListeners();

    try {
      final result = await _ayahByAyahRepository.fetchAyahsByIds(
        ayahIds: ayahIds,
      );

      _favoriteAyahs = result;
    } catch (e) {
      _favoritesError = e;
    } finally {
      _isFavoritesLoading = false;
      notifyListeners();
    }
  }

  Future<List<AyahByAyahEntity>> searchAyahs({required String query}) {
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      return Future.value(const []);
    }

    return _ayahByAyahRepository.searchAyahs(query: normalizedQuery);
  }

  void clearFavorites() {
    _favoriteAyahs = const [];
    _favoritesError = null;
    _isFavoritesLoading = false;
    notifyListeners();
  }
}
