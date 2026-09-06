import 'package:equatable/equatable.dart';

import '../../../../core/database/constants/column_names.dart';

class FortressFootnoteModel extends Equatable {
  const FortressFootnoteModel({
    required this.footnoteId,
    required this.footnote,
  });

  final int footnoteId;
  final String footnote;

  String get label => '[$footnoteId]';

  factory FortressFootnoteModel.fromMap(Map<String, dynamic> map) {
    return FortressFootnoteModel(
      footnoteId: map[ColumnNames.footnoteId] as int,
      footnote: map[ColumnNames.footnote] as String,
    );
  }

  @override
  List<Object?> get props => [footnoteId, footnote];
}
