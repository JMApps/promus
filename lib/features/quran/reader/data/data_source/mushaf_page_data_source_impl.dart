import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/database/constants/table_names.dart';
import '../models/mushaf_page_row_model.dart';
import 'mushaf_page_local_data_source.dart';

class MushafPageDataSourceImpl implements MushafPageLocalDataSource {
  final Database _database;

  const MushafPageDataSourceImpl(this._database);

  @override
  Future<List<MushafPageRowModel>> fetchPageData({
    required int pageNumber,
    required String translationColumn,
  }) async {
    final result = await _database.rawQuery(
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

    return result.map(MushafPageRowModel.fromMap).toList(growable: false);
  }
}
