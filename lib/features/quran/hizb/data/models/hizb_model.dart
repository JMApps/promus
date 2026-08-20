import '../../../../../core/database/constants/column_names.dart';

class HizbModel {
  final int hizbNumber;
  final int versesCount;
  final String firstVerseKey;
  final String lastVerseKey;
  final int startPageNumber;

  const HizbModel({
    required this.hizbNumber,
    required this.versesCount,
    required this.firstVerseKey,
    required this.lastVerseKey,
    required this.startPageNumber,
  });

  factory HizbModel.fromMap(Map<String, Object?> map) {
    return HizbModel(
      hizbNumber: map[ColumnNames.hizbNumber] as int,
      versesCount: map[ColumnNames.versesCount] as int,
      firstVerseKey: map[ColumnNames.firstVerseKey] as String,
      lastVerseKey: map[ColumnNames.lastVerseKey] as String,
      startPageNumber: map[ColumnNames.startPageNumber] as int,
    );
  }
}
