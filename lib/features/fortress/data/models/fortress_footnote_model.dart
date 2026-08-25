import 'package:equatable/equatable.dart';

class FortressFootnoteModel extends Equatable {
  const FortressFootnoteModel({
    required this.footnoteId,
    required this.footnote,
  });

  final int footnoteId;
  final String footnote;

  String get label => '[$footnoteId]';

  @override
  List<Object?> get props => [footnoteId, footnote];
}
