import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/database/constants/table_names.dart';
import '../models/ayah_by_ayah_model.dart';
import 'ayah_by_ayah_local_data_source.dart';

class AyahByAyahDataSourceImpl implements AyahByAyahLocalDataSource {
  final Database _database;

  const AyahByAyahDataSourceImpl(this._database);

  @override
  Future<List<AyahByAyahModel>> searchAyahs({
    required String query,
    required String translationColumn,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(trimmed);
    final matchExpr = trimmed.split(RegExp(r'\s+')).map((w) => '$w*').join(' ');

    if (isArabic) {
      final result = await _database.rawQuery(
        '''
        SELECT
          a.${ColumnNames.ayahId},
          a.${ColumnNames.verseKey},
          a.${ColumnNames.surahNumber},
          a.${ColumnNames.ayahNumber},
          a.${ColumnNames.ayahNormalized} AS ${ColumnNames.ayahArabic},
          a.${ColumnNames.ayahPageNumber},
          a.${ColumnNames.ayahPosition},
          COALESCE(t.$translationColumn, '') AS ${ColumnNames.ayahTranslation}
        FROM ${TableNames.tableOfAyah} fts
        JOIN ${TableNames.tableOfAyah} a ON a.${ColumnNames.ayahId} = fts.rowid
        LEFT JOIN ${TableNames.tableOfTranslations} t ON t.id = a.${ColumnNames.ayahId}
        WHERE ${TableNames.tableOfAyah} MATCH ?
        ORDER BY a.${ColumnNames.surahNumber}, a.${ColumnNames.ayahNumber}
        ''',
        [matchExpr],
      );
      return result.map(AyahByAyahModel.fromMap).toList(growable: false);
    }

    final result = await _database.rawQuery(
      '''
      SELECT
        a.${ColumnNames.ayahId},
        a.${ColumnNames.verseKey},
        a.${ColumnNames.surahNumber},
        a.${ColumnNames.ayahNumber},
        a.${ColumnNames.ayah} AS ${ColumnNames.ayahArabic},
        a.${ColumnNames.ayahPageNumber},
        a.${ColumnNames.ayahPosition},
        COALESCE(t.$translationColumn, '') AS ${ColumnNames.ayahTranslation}
      FROM ${TableNames.tableOfTranslations} fts
      JOIN ${TableNames.tableOfAyah} a ON a.${ColumnNames.ayahId} = fts.rowid
      LEFT JOIN ${TableNames.tableOfTranslations} t ON t.id = a.${ColumnNames.ayahId}
      WHERE ${TableNames.tableOfTranslations} MATCH ?
      ORDER BY a.${ColumnNames.surahNumber}, a.${ColumnNames.ayahNumber}
      ''',
      ['$translationColumn:$matchExpr'],
    );
    return result.map(AyahByAyahModel.fromMap).toList(growable: false);
  }

  @override
  Future<List<AyahByAyahModel>> fetchAyahsByIds({
    required List<int> ayahIds,
    required String translationColumn,
  }) async {
    if (ayahIds.isEmpty) return const [];

    final placeholders = List.filled(ayahIds.length, '?').join(',');
    final result = await _database.rawQuery(
      '''
      SELECT
        a.${ColumnNames.ayahId},
        a.${ColumnNames.verseKey},
        a.${ColumnNames.surahNumber},
        a.${ColumnNames.ayahNumber},
        a.${ColumnNames.ayah} AS ${ColumnNames.ayahArabic},
        a.${ColumnNames.ayahPageNumber},
        a.${ColumnNames.ayahPosition},
        COALESCE(t.$translationColumn, '') AS ${ColumnNames.ayahTranslation}
      FROM ${TableNames.tableOfAyah} a
      LEFT JOIN ${TableNames.tableOfTranslations} t
        ON t.id = a.${ColumnNames.ayahId}
      WHERE a.${ColumnNames.ayahId} IN ($placeholders)
      ''',
      ayahIds,
    );

    final orderMap = {for (var i = 0; i < ayahIds.length; i++) ayahIds[i]: i};
    final models = result.map(AyahByAyahModel.fromMap).toList();
    models.sort(
      (a, b) => (orderMap[a.ayahId] ?? 1 << 30).compareTo(
        orderMap[b.ayahId] ?? 1 << 30,
      ),
    );
    return List.unmodifiable(models);
  }
}
