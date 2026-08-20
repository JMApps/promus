import '../../../../../core/database/constants/column_names.dart';

class PageMetaModel {
  final int pageNumber;
  final int surahNumber;
  final int juzNumber;
  final int? hizbNumber;

  const PageMetaModel({
    required this.pageNumber,
    required this.surahNumber,
    required this.juzNumber,
    required this.hizbNumber,
  });

  factory PageMetaModel.fromMap(Map<String, Object?> map) {
    return PageMetaModel(
      pageNumber: map[ColumnNames.pageNumber] as int,
      surahNumber: map[ColumnNames.surahNumber] as int,
      juzNumber: map[ColumnNames.juzNumber] as int,
      hizbNumber: map[ColumnNames.hizbNumber] as int?,
    );
  }
}
