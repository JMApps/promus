import 'constants/table_names.dart';
import 'service/asset_database.dart';

class MushafDatabaseHelper extends AssetDatabase {
  MushafDatabaseHelper._() : super(
    assetPath: '${TableNames.databasesPath}${TableNames.mushafDatabaseName}',
    fileName: TableNames.mushafDatabaseName,
    version: 1,
  );

  static final MushafDatabaseHelper instance = MushafDatabaseHelper._();
}
