import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/database/constants/table_names.dart';
import '../models/hizb_model.dart';
import 'hizb_local_data_source.dart';

class HizbLocalDataSourceImpl implements HizbLocalDataSource {
  final Database _database;

  const HizbLocalDataSourceImpl(this._database);

  @override
  Future<List<HizbModel>> fetchAllHizbs() async {
    final rows = await _database.query(
      TableNames.tableOfHizb,
      orderBy: '${ColumnNames.hizbNumber} ASC',
    );
    return rows.map(HizbModel.fromMap).toList();
  }
}