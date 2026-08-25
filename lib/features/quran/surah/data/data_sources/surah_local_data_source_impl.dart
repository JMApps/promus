import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/database/constants/table_names.dart';
import '../../../../../core/database/database_helper.dart';
import '../models/surah_name_model.dart';
import 'surah_local_data_source.dart';

class SurahLocalDataSourceImpl implements SurahLocalDataSource {
  final DatabaseHelper _databaseHelper;

  const SurahLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<List<SurahNameModel>> fetchAllSurahs() async {
    final Database database = await _databaseHelper.db;
    final rows = await database.query(
      TableNames.tableOfSurahs,
      orderBy: '${ColumnNames.surahNumber} ASC',
    );
    return rows.map(SurahNameModel.fromMap).toList();
  }
}
