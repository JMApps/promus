import '../../../../core/database/constants/column_names.dart';

class MushafPageMetaModel {
  final int pageNumber;
  final int surahNumber;
  final int juzNumber;
  final int? hizbNumber;

  const MushafPageMetaModel({
    required this.pageNumber,
    required this.surahNumber,
    required this.juzNumber,
    required this.hizbNumber,
  });

  factory MushafPageMetaModel.fromMap(Map<String, Object?> map) {
    return MushafPageMetaModel(
      pageNumber: map[ColumnNames.pageNumber] as int,
      surahNumber: map[ColumnNames.surahNumber] as int,
      juzNumber: map[ColumnNames.juzNumber] as int,
      hizbNumber: map[ColumnNames.hizbNumber] as int?,
    );
  }
}
