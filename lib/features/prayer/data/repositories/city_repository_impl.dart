import '../../../../core/database/city_database_helper.dart';
import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/city_repository.dart';
import '../mappers/city_mapper.dart';
import '../models/city_model.dart';

class CityRepositoryImpl implements CityRepository {
  final CityDatabaseHelper _databaseHelper;

  CityRepositoryImpl(this._databaseHelper);

  @override
  Future<List<CityEntity>> fetchAllCities({required String country}) async {
    final database = await _databaseHelper.open();

    final rows = await database.query(
      TableNames.tableOfCityCoordinates,
      orderBy: 'CASE WHEN ${ColumnNames.country} = ? THEN 0 ELSE 1 END, ${ColumnNames.id}',
      whereArgs: [country],
    );

    return rows.map((row) => CityModel.fromMap(row).toEntity()).toList(growable: false);
  }
}
