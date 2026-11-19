import 'package:sqflite/sqflite.dart';

import '../../../../core/database/constants/column_names.dart';
import '../../../../core/database/constants/table_names.dart';
import '../../../../core/database/mushaf_database_helper.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';
import '../mappers/ayah_by_ayah_mapper.dart';
import '../models/ayah_by_ayah_model.dart';
import 'search_normalizer.dart';

class AyahByAyahRepositoryImpl implements AyahByAyahRepository {
  const AyahByAyahRepositoryImpl(this._databaseHelper);

  final MushafDatabaseHelper _databaseHelper;

  static const int _searchLimit = 200;

  static final String _selectColumns = '''
    a.${ColumnNames.ayahId},
    a.${ColumnNames.verseKey},
    a.${ColumnNames.surahNumber},
    a.${ColumnNames.ayahNumber},
    a.${ColumnNames.ayah} AS ${ColumnNames.ayahArabic},
    a.${ColumnNames.ayahPageNumber},
    a.${ColumnNames.ayahPosition},
    COALESCE(t.${ColumnNames.ayahRuKuliev}, '') AS ${ColumnNames.ayahTranslation}
  ''';

  @override
  Future<List<AyahByAyahEntity>> searchAyahs({required String query}) async {
    final isArabic = containsArabic(query);
    final words = splitSearchWords(
      isArabic ? normalizeArabic(query) : normalizeRussian(query),
    );
    if (words.isEmpty) return const [];

    final database = await _databaseHelper.db;

    final List<Map<String, Object?>> rows;
    if (isArabic) {
      final fts = TableNames.ftsArabicTable;

      // Для каждого слова берём первое написание, которое есть в индексе:
      // само слово или его османский вариант (см. arabicSpellingVariants).
      final terms = <String>[];
      for (final word in words) {
        terms.add(await _arabicTerm(database, fts, word));
      }

      rows = await database.rawQuery(
        '''
        SELECT $_selectColumns
        FROM $fts
        JOIN ${TableNames.tableOfAyah} a
          ON a.${ColumnNames.ayahId} = $fts.rowid
        LEFT JOIN ${TableNames.tableOfTranslations} t
          ON t.ayah_key = a.${ColumnNames.verseKey}
        WHERE $fts MATCH ?
        ORDER BY a.${ColumnNames.surahNumber}, a.${ColumnNames.ayahNumber}
        LIMIT $_searchLimit
        ''',
        [terms.join(' ')],
      );
    } else {
      // rowid в fts_translations — это Table_of_translation.id,
      // поэтому идём через таблицу переводов, а аят находим по ключу.
      final fts = TableNames.ftsTranslationsTable;
      final terms = words.map((word) => word.length > 1 ? '$word*' : word);
      rows = await database.rawQuery(
        '''
        SELECT $_selectColumns
        FROM $fts
        JOIN ${TableNames.tableOfTranslations} t
          ON t.id = $fts.rowid
        JOIN ${TableNames.tableOfAyah} a
          ON a.${ColumnNames.verseKey} = t.ayah_key
        WHERE $fts MATCH ?
        ORDER BY a.${ColumnNames.surahNumber}, a.${ColumnNames.ayahNumber}
        LIMIT $_searchLimit
        ''',
        [terms.map((term) => '${ColumnNames.ayahRuKuliev}:$term').join(' ')],
      );
    }

    return rows
        .map((row) => AyahByAyahModel.fromMap(row).ayahByAyahToEntity())
        .toList(growable: false);
  }

  /// Термин FTS для арабского слова: однобуквенное ищем целиком,
  /// остальные — по началу слова, в первом написании, которое есть в индексе.
  /// Каждая проверка — `LIMIT 1` по индексу FTS, доли миллисекунды.
  Future<String> _arabicTerm(DatabaseExecutor database, String fts, String word) async {
    if (word.length == 1) return word;
    for (final variant in arabicSpellingVariants(word)) {
      final hit = await database.rawQuery(
        'SELECT 1 FROM $fts WHERE $fts MATCH ? LIMIT 1',
        ['$variant*'],
      );
      if (hit.isNotEmpty) return '$variant*';
    }
    return '$word*';
  }

  @override
  Future<List<AyahByAyahEntity>> fetchAyahsByIds({
    required List<int> ayahIds,
  }) async {
    if (ayahIds.isEmpty) return const [];

    final database = await _databaseHelper.db;
    final placeholders = List.filled(ayahIds.length, '?').join(',');

    final rows = await database.rawQuery(
      '''
      SELECT $_selectColumns
      FROM ${TableNames.tableOfAyah} a
      LEFT JOIN ${TableNames.tableOfTranslations} t
        ON t.ayah_key = a.${ColumnNames.verseKey}
      WHERE a.${ColumnNames.ayahId} IN ($placeholders)
      ''',
      ayahIds,
    );

    final byId = {
      for (final row in rows)
        row[ColumnNames.ayahId] as int:
        AyahByAyahModel.fromMap(row).ayahByAyahToEntity(),
    };

    // Порядок как в ayahIds; несуществующие id пропускаются.
    return List.unmodifiable([for (final id in ayahIds) ?byId[id]]);
  }
}