import 'constants/table_names.dart';
import 'service/asset_database.dart';

class FortressDatabaseHelper extends AssetDatabase {
  FortressDatabaseHelper._() : super(
    assetPath: '${TableNames.databasesPath}${TableNames.fortressDatabaseName}',
    fileName: TableNames.fortressDatabaseName,
    version: 1,
  );

  static final FortressDatabaseHelper instance = FortressDatabaseHelper._();
}
