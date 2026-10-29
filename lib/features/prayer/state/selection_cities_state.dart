import 'package:flutter/material.dart';

import '../data/repositories/city_repository_impl.dart';
import '../domain/entities/city_entity.dart';

class AllCitiesState extends ChangeNotifier {
  final CityRepositoryImpl _cityRepository;

  AllCitiesState(this._cityRepository);

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void onEndSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<List<CityEntity>> fetchAllCities() async {
    return await _cityRepository.fetchAllCities();
  }
}
