import 'package:equatable/equatable.dart';

class CustomCityEntity extends Equatable {
  final int cityId;
  final String country;
  final String city;
  final double latitude;
  final double longitude;

  const CustomCityEntity({
    required this.cityId,
    required this.country,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    cityId,
    country,
    city,
    latitude,
    longitude,
  ];
}
