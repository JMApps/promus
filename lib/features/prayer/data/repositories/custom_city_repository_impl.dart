import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/custom_city_database_helper.dart';
import '../../domain/entities/custom_city_entity.dart';
import '../../domain/repositories/custom_city_repository.dart';
import '../mappers/custom_city_mapper.dart';
import '../models/custom_city_model.dart';

class CustomCityRepositoryImpl implements CustomCityRepository {
  final CustomCityDatabaseHelper _databaseHelper;

  CustomCityRepositoryImpl(this._databaseHelper);

  @override
  Future<List<CustomCityEntity>> fetchAllCustomCities() async {
    final database = await _databaseHelper.db;

    final rows = await database.query(
      TableNames.tableOfCityCoordinates,
      orderBy: ColumnNames.id,
      limit: 500,
    );

    return rows.map((row) => CustomCityModel.fromMap(row).toEntity()).toList(growable: false);
  }

  @override
  Future<CustomCityEntity> createCity({required String country, required String city, required double latitude, required double longitude}) async {
    final database = await _databaseHelper.db;

    final id = await database.insert(TableNames.tableOfCityCoordinates, {
      ColumnNames.country: country,
      ColumnNames.city: city,
      ColumnNames.latitude: latitude,
      ColumnNames.longitude: longitude,
    });

    return CustomCityEntity(
      cityId: id,
      country: country,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> updateCity(CustomCityEntity city) async {
    final database = await _databaseHelper.db;

    final count = await database.update(
      TableNames.tableOfCityCoordinates,
      city.toModel().toMap(),
      where: '${ColumnNames.id} = ?',
      whereArgs: [city.cityId],
    );

    if (count == 0) {
      throw StateError('Custom city ${city.cityId} not found');
    }
  }

  @override
  Future<void> deleteCity(int cityId) async {
    final database = await _databaseHelper.db;

    await database.delete(
      TableNames.tableOfCityCoordinates,
      where: '${ColumnNames.id} = ?',
      whereArgs: [cityId],
    );
  }

}