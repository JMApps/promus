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
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(trimmed);

    final words = (isArabic ? _normalizeArabic(trimmed) : trimmed)
        .split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'["*]'), ''))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return const [];

    final column = isArabic ? ColumnNames.ayahNormalized : ColumnNames.ayahRuKuliev;
    final matchExpr = words.map((w) => '$column:"$w"*').join(' ');

    final database = await _databaseHelper.db;

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
    FROM fts_ayahs
    JOIN ${TableNames.tableOfAyah} a ON a.${ColumnNames.ayahId} = fts_ayahs.rowid
    LEFT JOIN ${TableNames.tableOfTranslations} t ON t.ayah_key = a.${ColumnNames.verseKey}
    WHERE fts_ayahs MATCH ?
    ORDER BY a.${ColumnNames.surahNumber}, a.${ColumnNames.ayahNumber}
    ''',
      [matchExpr],
    );

    return result
        .map((row) => AyahByAyahModel.fromMap(row).ayahByAyahToEntity())
        .toList(growable: false);
  }

  static String _normalizeArabic(String s) {
    return s
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED\u0640]'), '')
        .replaceAll(RegExp(r'[\u0622\u0623\u0625\u0671]'), '\u0627')
        .replaceAll('\u0649', '\u0649');
  }

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