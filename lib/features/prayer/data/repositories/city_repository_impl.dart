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
  Future<List<CityEntity>> fetchAllCities() async {
    final database = await _databaseHelper.db;

    final rows = await database.query(
      TableNames.tableOfCityCoordinates,
      orderBy: ColumnNames.id,
      limit: 500,
    );

    return rows.map((row) => CityModel.fromMap(row).toEntity()).toList(growable: false);
  }
}
