import 'constants/table_names.dart';
import 'service/asset_database.dart';

class CustomCityDatabaseHelper extends AssetDatabase {
  CustomCityDatabaseHelper._() : super(
    assetPath: '${TableNames.databasesPath}${TableNames.customCityDatabaseName}',
    fileName: TableNames.customCityDatabaseName,
    version: 1,
  );

  static final CustomCityDatabaseHelper instance = CustomCityDatabaseHelper._();
}