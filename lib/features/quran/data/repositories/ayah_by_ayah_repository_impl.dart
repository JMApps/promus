import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/mushaf_database_helper.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';
import '../mappers/ayah_by_ayah_mapper.dart';
import '../models/ayah_by_ayah_model.dart';

class AyahByAyahRepositoryImpl implements AyahByAyahRepository {
  final MushafDatabaseHelper _databaseHelper;

  const AyahByAyahRepositoryImpl(this._databaseHelper);

  @override
  Future<List<AyahByAyahEntity>> searchAyahs({required String query}) async {
    final database = await _databaseHelper.db;

    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(trimmed);
    final matchExpr = trimmed.split(RegExp(r'\s+')).map((w) => '$w*').join(' ');

    if (isArabic) {
      final result = await database.rawQuery(
        '''
        SELECT
          a.${ColumnNames.ayahId},
          a.${ColumnNames.verseKey},
          a.${ColumnNames.surahNumber},
          a.${ColumnNames.ayahNumber},
          a.${ColumnNames.ayahNormalized} AS ${ColumnNames.ayahArabic},
          a.${ColumnNames.ayahPageNumber},
          a.${ColumnNames.ayahPosition},
          COALESCE(t.${ColumnNames.ayahRuKuliev}, '') AS ${ColumnNames.ayahTranslation}
        FROM ${TableNames.tableOfAyah} fts
        JOIN ${TableNames.tableOfAyah} a ON a.${ColumnNames.ayahId} = fts.rowid
        LEFT JOIN ${TableNames.tableOfTranslations} t ON t.id = a.${ColumnNames.ayahId}
        WHERE ${TableNames.tableOfAyah} MATCH ?
        ORDER BY a.${ColumnNames.surahNumber}, a.${ColumnNames.ayahNumber}
        ''',
        [matchExpr],
      );
      return result.map((row) => AyahByAyahModel.fromMap(row).ayahByAyahToEntity()).toList(growable: false);
    }

    final result = await database.rawQuery(
      '''
      SELECT
        a.${ColumnNames.ayahId},
        a.${ColumnNames.verseKey},
        a.${ColumnNames.surahNumber},
        a.${ColumnNames.ayahNumber},
        a.${ColumnNames.ayah} AS ${ColumnNames.ayahArabic},
        a.${ColumnNames.ayahPageNumber},
        a.${ColumnNames.ayahPosition},
        COALESCE(t.${ColumnNames.ayahRuKuliev}, '') AS ${ColumnNames.ayahTranslation}
      FROM ${TableNames.tableOfTranslations} fts
      JOIN ${TableNames.tableOfAyah} a ON a.${ColumnNames.ayahId} = fts.rowid
      LEFT JOIN ${TableNames.tableOfTranslations} t ON t.id = a.${ColumnNames.ayahId}
      WHERE ${TableNames.tableOfTranslations} MATCH ?
      ORDER BY a.${ColumnNames.surahNumber}, a.${ColumnNames.ayahNumber}
      ''',
      ['${ColumnNames.ayahRuKuliev}:$matchExpr'],
    );
    return result.map((row) => AyahByAyahModel.fromMap(row).ayahByAyahToEntity()).toList(growable: false);  }

  @override
  Future<List<AyahByAyahEntity>> fetchAyahsByIds({required List<int> ayahIds}) async {
    final database = await _databaseHelper.db;

    if (ayahIds.isEmpty) return const [];

    final placeholders = List.filled(ayahIds.length, '?').join(',');
    final result = await database.rawQuery(
      '''
      SELECT
        a.${ColumnNames.ayahId},
        a.${ColumnNames.verseKey},
        a.${ColumnNames.surahNumber},
        a.${ColumnNames.ayahNumber},
        a.${ColumnNames.ayah} AS ${ColumnNames.ayahArabic},
        a.${ColumnNames.ayahPageNumber},
        a.${ColumnNames.ayahPosition},
        COALESCE(t.${ColumnNames.ayahRuKuliev}, '') AS ${ColumnNames.ayahTranslation}
      FROM ${TableNames.tableOfAyah} a
      LEFT JOIN ${TableNames.tableOfTranslations} t
        ON t.id = a.${ColumnNames.ayahId}
      WHERE a.${ColumnNames.ayahId} IN ($placeholders)
      ''',
      ayahIds,
    );

    final orderMap = {for (var i = 0; i < ayahIds.length; i++) ayahIds[i]: i};
    final models = result.map(AyahByAyahModel.fromMap).toList();
    models.sort((a, b) => (orderMap[a.ayahId] ?? 1 << 30).compareTo(orderMap[b.ayahId] ?? 1 << 30));

    return List.unmodifiable(models);
  }
}