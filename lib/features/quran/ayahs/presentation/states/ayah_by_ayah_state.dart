import 'package:flutter/foundation.dart';

import '../../../../../core/constants/app_device_locales.dart';
import '../../../settings/states/locale_settings_state.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';

class AyahByAyahState extends ChangeNotifier {
  AyahByAyahState(this._ayahByAyahRepository, this._localeSettingsState) {
    _localeSettingsState.addListener(_onSettingsChanged);
  }

  final AyahByAyahRepository _ayahByAyahRepository;
  final LocaleSettingsState _localeSettingsState;

  List<int> _lastFavoriteAyahIds = const [];

  List<AyahByAyahEntity> _favoriteAyahs = const [];
  bool _isFavoritesLoading = false;
  Object? _favoritesError;

  List<AyahByAyahEntity> get favoriteAyahs => _favoriteAyahs;

  bool get isFavoritesLoading => _isFavoritesLoading;

  Object? get favoritesError => _favoritesError;

  String get translationsColumn {
    return AppDeviceLocales
        .ayahTranslations[_localeSettingsState.translationNameIndex]
        .column;
  }

  Future<void> loadFavoriteAyahs(List<int> ayahIds) async {
    _lastFavoriteAyahIds = List.unmodifiable(ayahIds);

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
        translationColumn: translationsColumn,
      );

      _favoriteAyahs = result;
    } catch (e) {
      _favoritesError = e;
    } finally {
      _isFavoritesLoading = false;
      notifyListeners();
    }
  }

  Future<List<AyahByAyahEntity>> searchAyahs({
    required String query,
  }) {
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      return Future.value(const []);
    }

    return _ayahByAyahRepository.searchAyahs(
      query: normalizedQuery,
      translationColumn: translationsColumn,
    );
  }

  void clearFavorites() {
    _lastFavoriteAyahIds = const [];
    _favoriteAyahs = const [];
    _favoritesError = null;
    _isFavoritesLoading = false;
    notifyListeners();
  }

  void _onSettingsChanged() {
    if (_lastFavoriteAyahIds.isEmpty) {
      _favoriteAyahs = const [];
      _favoritesError = null;
      _isFavoritesLoading = false;
      notifyListeners();
      return;
    }

    loadFavoriteAyahs(_lastFavoriteAyahIds);
  }

  @override
  void dispose() {
    _localeSettingsState.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
