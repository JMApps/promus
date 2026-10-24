import 'package:equatable/equatable.dart';

class FortressFootnoteEntity extends Equatable {
  const FortressFootnoteEntity({
    required this.footnoteId,
    required this.footnote,
  });

  final int footnoteId;
  final String footnote;

  String get label => '[$footnoteId]';

  @override
  List<Object?> get props => [footnoteId, footnote];
}
