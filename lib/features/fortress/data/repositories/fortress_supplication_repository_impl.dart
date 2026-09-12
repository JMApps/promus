import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/fortress_database_helper.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../../domain/repositories/fortress_supplication_repository.dart';
import '../mappers/fortress_supplication_mapper.dart';
import '../models/fortress_supplication_model.dart';

class FortressSupplicationRepositoryImpl implements FortressSupplicationRepository {
  final FortressDatabaseHelper _databaseHelper;

  FortressSupplicationRepositoryImpl(this._databaseHelper);

  @override
  Future<List<FortressSupplicationEntity>> fetchSupplicationsByChapter({required int chapterId}) async {
    final db = await _databaseHelper.db;

    final rows = await db.query(
      TableNames.tableOfSupplications,
      where: '${ColumnNames.sampleBy} = ?',
      whereArgs: [chapterId],
    );

    return rows.map(FortressSupplicationModel.fromMap).toList(growable: false).toEntities();
  }

  @override
  Future<FortressSupplicationEntity> fetchSupplicationById({required int supplicationId}) async {
    final db = await _databaseHelper.db;

    final rows = await db.query(
      TableNames.tableOfSupplications,
      where: '${ColumnNames.supplicationId} = ?',
      whereArgs: [supplicationId],
      limit: 1,
    );

    return FortressSupplicationModel.fromMap(rows.first).toEntity();
  }
}
