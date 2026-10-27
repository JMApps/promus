import '../../domain/entities/custom_city_entity.dart';
import '../models/custom_city_model.dart';

extension CustomCityModelMapper on CustomCityModel {
  CustomCityEntity toEntity() {
    return CustomCityEntity(
      cityId: cityId,
      country: country,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

extension CustomCityEntityMapper on CustomCityEntity {
  CustomCityModel toModel() {
    return CustomCityModel(
      cityId: cityId,
      country: country,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

extension CustomCityListMapper on List<CustomCityModel> {
  List<CustomCityEntity> toEntities() => map((model) => model.toEntity()).toList(growable: false);
}