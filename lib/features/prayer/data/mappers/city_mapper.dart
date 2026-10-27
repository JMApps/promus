import '../../domain/entities/city_entity.dart';
import '../models/city_model.dart';

extension CityMapper on CityModel {
  CityEntity toEntity() {
    return CityEntity(
      cityId: cityId,
      country: country,
      city: city,
      iso: iso,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

extension CityListMapper on List<CityModel> {
  List<CityEntity> toEntities() => map((model) => model.toEntity()).toList(growable: false);
}
