import '../../../../core/database/constants/column_names.dart';

class FortressFootnoteModel {
  const FortressFootnoteModel({
    required this.footnoteId,
    required this.footnote,
  });

  final int footnoteId;
  final String footnote;
  
  factory FortressFootnoteModel.fromMap(Map<String, dynamic> map) {
    return FortressFootnoteModel(
      footnoteId: map[ColumnNames.footnoteId] as int,
      footnote: map[ColumnNames.footnote] as String,
    );
  }
}
