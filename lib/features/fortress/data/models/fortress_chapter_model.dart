import '../../../../core/database/constants/column_names.dart';

class FortressChapterModel {
  final int chapterId;
  final String chapterNumber;
  final String chapterTitle;

  const FortressChapterModel({
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
  });

  factory FortressChapterModel.fromMap(Map<String, Object?> map) {
    return FortressChapterModel(
      chapterId: map[ColumnNames.chapterId] as int,
      chapterNumber: map[ColumnNames.chapterNumber] as String,
      chapterTitle: map[ColumnNames.chapterTitle] as String,
    );
  }
}
