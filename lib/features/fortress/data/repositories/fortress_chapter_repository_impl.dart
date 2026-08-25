import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/fortress_database_helper.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/repositories/fortress_chapter_repository.dart';
import '../mappers/fortress_chapter_mapper.dart';
import '../models/fortress_chapter_model.dart';

class FortressChapterRepositoryImpl implements FortressChapterRepository {
  const FortressChapterRepositoryImpl(this._databaseHelper);

  final FortressDatabaseHelper _databaseHelper;

  @override
  Future<List<FortressChapterEntity>> fetchAllChapters() async {
    final db = await _databaseHelper.db;

    final rows = await db.query(
      TableNames.tableOfFortressChapters,
      orderBy: ColumnNames.chapterId,
    );

    return rows.map(FortressChapterModel.fromMap).toList(growable: false).toEntities();
  }
}
