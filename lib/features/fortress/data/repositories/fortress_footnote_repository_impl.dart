import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/fortress_database_helper.dart';
import '../../domain/entities/fortress_footnote_entity.dart';
import '../../domain/repositories/fortress_footnote_repository.dart';
import '../mappers/fortress_footnote_mapper.dart';
import '../models/fortress_footnote_model.dart';

class FortressFootnoteRepositoryImpl implements FortressFootnoteRepository {
  final FortressDatabaseHelper _databaseHelper;
  const FortressFootnoteRepositoryImpl(this._databaseHelper);

  @override
  Future<FortressFootnoteEntity> fetchFootnoteById({required int footnoteId}) async {
    final db = await _databaseHelper.db;

    final rows = await db.query(
      TableNames.tableOfFortressFootnotes,
      where: '${ColumnNames.footnoteId} = ?',
      whereArgs: [footnoteId],
      limit: 1,
    );

    return FortressFootnoteModel.fromMap(rows.first).toEntity();
  }
}
