import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/database/constants/table_names.dart';
import '../models/surah_name_model.dart';
import 'surah_local_data_source.dart';

class SurahLocalDataSourceImpl implements SurahLocalDataSource {
  final Database _database;

  const SurahLocalDataSourceImpl(this._database);

  @override
  Future<List<SurahNameModel>> fetchAllSurahs() async {
    final rows = await _database.query(
      TableNames.tableOfSurahs,
      orderBy: '${ColumnNames.surahNumber} ASC',
    );
    return rows.map(SurahNameModel.fromMap).toList();
  }
}
