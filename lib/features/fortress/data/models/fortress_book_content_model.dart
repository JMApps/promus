import '../../../../core/database/constants/column_names.dart';

class FortressBookContentModel {
  final int bookContentId;
  final String bookContentTitle;
  final String bookContent;

  const FortressBookContentModel({
    required this.bookContentId,
    required this.bookContentTitle,
    required this.bookContent,
  });

  factory FortressBookContentModel.fromMap(Map<String, Object?> map) {
    return FortressBookContentModel(
      bookContentId: map[ColumnNames.bookContentId] as int,
      bookContentTitle: map[ColumnNames.bookContentTitle] as String,
      bookContent: map[ColumnNames.bookContent] as String,
    );
  }
}
