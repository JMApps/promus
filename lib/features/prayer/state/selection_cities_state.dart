import 'dart:async';

import 'package:flutter/material.dart';

import '../data/repositories/city_repository_impl.dart';
import '../domain/entities/city_entity.dart';

class AllCitiesState extends ChangeNotifier {
  AllCitiesState(this._repo, this._country);

  final CityRepositoryImpl _repo;
  final String _country;

  List<CityEntity> _all = const [];
  List<String> _index = const [];
  List<CityEntity> _filtered = const [];
  Object? _error;
  bool _isLoading = true;
  String _query = '';
  Timer? _debounce;

  List<CityEntity> get cities => _filtered;
  Object? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> loadAllCitiesList() async {
    try {
      _all = await _repo.fetchAllCities(country: _country);
      _index = [
        for (final c in _all) '${c.city} ${c.country} ${c.iso}'.toLowerCase(),
      ];
      _filtered = _all;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _query = query.toLowerCase().trim();
      if (_query.isEmpty) {
        _filtered = _all;
      } else {
        final result = <CityEntity>[];
        for (var i = 0; i < _all.length; i++) {
          if (_index[i].contains(_query)) result.add(_all[i]);
        }
        _filtered = result;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}