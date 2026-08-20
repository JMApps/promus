import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/database/constants/table_names.dart';
import '../models/juz_model.dart';
import 'juz_local_data_source.dart';

class JuzLocalDataSourceImpl implements JuzLocalDataSource {
  final Database _database;

  const JuzLocalDataSourceImpl(this._database);

  @override
  Future<List<JuzModel>> fetchAllJuzs() async {
    final rows = await _database.query(
      TableNames.tableOfJuz,
      orderBy: '${ColumnNames.juzNumber} ASC',
    );
    return rows.map(JuzModel.fromMap).toList();
  }
}