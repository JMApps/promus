import '../entities/custom_city_entity.dart';

abstract interface class CustomCityRepository {

  Future<List<CustomCityEntity>> fetchAllCustomCities();

  Future<CustomCityEntity> createCity({required String country, required String city, required double latitude, required double longitude});

  Future<void> updateCity(CustomCityEntity city);

  Future<void> deleteCity(int cityId);
}
