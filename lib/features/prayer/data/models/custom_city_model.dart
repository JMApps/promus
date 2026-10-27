import '../../../../core/database/constants/column_names.dart';

class CustomCityModel {
  final int cityId;
  final String country;
  final String city;
  final double latitude;
  final double longitude;

  const CustomCityModel({
    required this.cityId,
    required this.country,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory CustomCityModel.fromMap(Map<String, dynamic> map) {
    return CustomCityModel(
      cityId: map[ColumnNames.id] as int,
      country: map[ColumnNames.country] as String,
      city: map[ColumnNames.city] as String,
      latitude: map[ColumnNames.latitude] as double,
      longitude: map[ColumnNames.longitude] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ColumnNames.country: country,
      ColumnNames.city: city,
      ColumnNames.latitude: latitude,
      ColumnNames.longitude: longitude,
    };
  }
}
