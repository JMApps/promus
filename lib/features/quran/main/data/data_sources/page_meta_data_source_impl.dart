import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/constants/column_names.dart';
import '../../../../../core/database/constants/table_names.dart';
import '../models/page_meta_model.dart';
import 'page_meta_local_data_source.dart';

class PageMetaDataSourceImpl implements PageMetaLocalDataSource {
  final Database _database;

  const PageMetaDataSourceImpl(this._database);

  @override
  Future<List<PageMetaModel>> fetchAppPagesMeta() async {
    final List<Map<String, Object?>> surahRows = await _database.rawQuery(
      '''
      SELECT ${ColumnNames.surahNumber}, ${ColumnNames.startPageNumber}
      FROM ${TableNames.tableOfSurahs}
      ORDER BY ${ColumnNames.startPageNumber} ASC
      ''',
    );

    final List<Map<String, Object?>> juzRows = await _database.rawQuery(
      '''
      SELECT ${ColumnNames.juzNumber}, ${ColumnNames.startPageNumber}
      FROM ${TableNames.tableOfJuz}
      ORDER BY ${ColumnNames.startPageNumber} ASC
      ''',
    );

    final List<Map<String, Object?>> hizbRows = await _database.rawQuery(
      '''
      SELECT ${ColumnNames.hizbNumber}, ${ColumnNames.startPageNumber}
      FROM ${TableNames.tableOfHizb}
      ORDER BY ${ColumnNames.startPageNumber} ASC
      ''',
    );

    final int totalPages = 604;

    final List<int> surahPerPage = _expandRanges(
      rows: surahRows,
      numberKey: ColumnNames.surahNumber,
      startPageKey: ColumnNames.startPageNumber,
      totalPages: totalPages,
    );

    final List<int> juzPerPage = _expandRanges(
      rows: juzRows,
      numberKey: ColumnNames.juzNumber,
      startPageKey: ColumnNames.startPageNumber,
      totalPages: totalPages,
    );

    final Map<int, int> hizbByPage = {
      for (final row in hizbRows)
        row[ColumnNames.startPageNumber] as int:
            row[ColumnNames.hizbNumber] as int,
    };

    final List<PageMetaModel> pagesMeta = List<PageMetaModel>.generate(
      totalPages,
      (int i) {
        final int pageNumber = i + 1;
        return PageMetaModel(
          pageNumber: pageNumber,
          surahNumber: surahPerPage[i],
          juzNumber: juzPerPage[i],
          hizbNumber: hizbByPage[pageNumber],
        );
      },
      growable: false,
    );

    return pagesMeta;
  }

  List<int> _expandRanges({
    required List<Map<String, Object?>> rows,
    required String numberKey,
    required String startPageKey,
    required int totalPages,
  }) {
    final List<int> result = List<int>.filled(totalPages, 0);
    if (rows.isEmpty) return result;

    int currentNumber = rows.first[numberKey] as int;
    int rowIndex = 0;

    for (int page = 1; page <= totalPages; page++) {
      while (rowIndex + 1 < rows.length &&
          (rows[rowIndex + 1][startPageKey] as int) <= page) {
        rowIndex++;
        currentNumber = rows[rowIndex][numberKey] as int;
      }
      result[page - 1] = currentNumber;
    }

    return result;
  }
}
