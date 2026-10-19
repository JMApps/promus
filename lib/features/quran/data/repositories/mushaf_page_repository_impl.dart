import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/mushaf_database_helper.dart';
import '../../domain/entities/mushaf_page_entity.dart';
import '../../domain/repositories/mushaf_page_repository.dart';
import '../mappers/mushaf_page_mapper.dart';
import '../models/mushaf_page_model.dart';

class MushafPageRepositoryImpl implements MushafPageRepository {
  final MushafDatabaseHelper _databaseHelper;

  const MushafPageRepositoryImpl(this._databaseHelper);

  @override
  Future<List<MushafPageEntity>> fetchMushafPageData({required int pageNumber, required String translationColumn}) async {
    final db = await _databaseHelper.db;

    final result = await db.rawQuery(
      '''
      WITH page_layout AS (
        SELECT 
          ${ColumnNames.pageNumber},
          ${ColumnNames.lineNumber},
          ${ColumnNames.lineType},
          ${ColumnNames.isCentered},
          ${ColumnNames.firstWordId},
          ${ColumnNames.lastWordId},
          ${ColumnNames.numberSurah}
        FROM ${TableNames.tableOfLayout}
        WHERE ${ColumnNames.pageNumber} = ?
      )
      SELECT 
        pl.${ColumnNames.lineNumber},
        pl.${ColumnNames.lineType},
        pl.${ColumnNames.isCentered},
        pl.${ColumnNames.numberSurah},
        pl.${ColumnNames.firstWordId},
        pl.${ColumnNames.lastWordId},
        g.${ColumnNames.id},
        g.${ColumnNames.surahNumber},
        g.${ColumnNames.ayahNumber},
        g.${ColumnNames.wordNumber},
        g.${ColumnNames.glyph},
        g.${ColumnNames.word},
        a.ayah_id AS ayah_id,
        a.ayah AS arabic_ayah,
        t.$translationColumn AS translation
      FROM page_layout pl
      LEFT JOIN ${TableNames.tableOfGlyph} g ON (
        pl.${ColumnNames.firstWordId} IS NOT NULL 
        AND g.${ColumnNames.id} BETWEEN pl.${ColumnNames.firstWordId} AND pl.${ColumnNames.lastWordId}
      )
      LEFT JOIN ${TableNames.tableOfAyah} a ON (
        g.${ColumnNames.surahNumber} = a.${ColumnNames.surahNumber} 
        AND g.${ColumnNames.ayahNumber} = a.${ColumnNames.ayahNumber}
      )
      LEFT JOIN ${TableNames.tableOfTranslations} t ON (
        g.${ColumnNames.surahNumber} = t.sura 
        AND g.${ColumnNames.ayahNumber} = t.ayah
      )
      ORDER BY pl.${ColumnNames.lineNumber}, g.${ColumnNames.id}
      ''',
      [pageNumber],
    );

    return result.map((row) => MushafPageModel.fromMap(row).mushafPageToEntity()).toList(growable: false);
  }
}
