import '../../../../core/database/constants/column_names.dart';

class CityModel {
  final int cityId;
  final String country;
  final String city;
  final String iso;
  final double latitude;
  final double longitude;

  const CityModel({
    required this.cityId,
    required this.country,
    required this.city,
    required this.iso,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      cityId: map[ColumnNames.id] as int,
      country: map[ColumnNames.country] as String,
      city: map[ColumnNames.city] as String,
      iso: map[ColumnNames.iso] as String,
      latitude: map[ColumnNames.latitude] as double,
      longitude: map[ColumnNames.longitude] as double,
    );
  }
}
