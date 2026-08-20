import '../../../../../core/database/constants/column_names.dart';

class JuzModel {
  final int juzNumber;
  final int versesCount;
  final String firstVerseKey;
  final String lastVerseKey;
  final int startPageNumber;

  const JuzModel({
    required this.juzNumber,
    required this.versesCount,
    required this.firstVerseKey,
    required this.lastVerseKey,
    required this.startPageNumber,
  });

  factory JuzModel.fromMap(Map<String, Object?> map) {
    return JuzModel(
      juzNumber: map[ColumnNames.juzNumber] as int,
      versesCount: map[ColumnNames.versesCount] as int,
      firstVerseKey: map[ColumnNames.firstVerseKey] as String,
      lastVerseKey: map[ColumnNames.lastVerseKey] as String,
      startPageNumber: map[ColumnNames.startPageNumber] as int,
    );
  }
}
