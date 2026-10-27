import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int cityId;
  final String country;
  final String city;
  final String iso;
  final double latitude;
  final double longitude;

  const CityEntity({
    required this.cityId,
    required this.country,
    required this.city,
    required this.iso,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    cityId,
    country,
    city,
    iso,
    latitude,
    longitude,
  ];
}
