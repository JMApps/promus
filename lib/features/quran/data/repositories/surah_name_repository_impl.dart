import 'package:sqflite/sqflite.dart';

import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/mushaf_database_helper.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';
import '../mappers/surah_name_mapper.dart';
import '../models/surah_name_model.dart';

class SurahNameRepositoryImpl implements SurahNameRepository {
  final MushafDatabaseHelper _databaseHelper;

  const SurahNameRepositoryImpl(this._databaseHelper);

  @override
  Future<List<SurahNameEntity>> fetchAllSurahs() async {
    final Database database = await _databaseHelper.db;
    final rows = await database.query(
      TableNames.tableOfSurahs,
      orderBy: '${ColumnNames.surahNumber} ASC',
    );
    return rows.map((row) => SurahNameModel.fromMap(row).surahNameToEntity()).toList();
  }
}