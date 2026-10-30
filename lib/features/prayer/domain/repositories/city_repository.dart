import '../entities/city_entity.dart';

abstract interface class CityRepository {
  Future<List<CityEntity>> fetchAllCities({required String country});
}
