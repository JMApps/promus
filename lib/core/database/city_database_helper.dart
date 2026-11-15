import 'constants/table_names.dart';
import 'service/asset_database.dart';

class CityDatabaseHelper extends AssetDatabase {
  CityDatabaseHelper._() : super(
    assetPath: '${TableNames.databasesPath}${TableNames.cityDatabaseName}',
    fileName: TableNames.cityDatabaseName,
    version: 1,
  );

  static final CityDatabaseHelper instance = CityDatabaseHelper._();
}
