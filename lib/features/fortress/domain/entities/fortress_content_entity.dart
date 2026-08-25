import 'package:equatable/equatable.dart';

class FortressBookContentEntity extends Equatable {
  final int bookContentId;
  final String bookContentTitle;
  final String bookContent;

  const FortressBookContentEntity({
    required this.bookContentId,
    required this.bookContentTitle,
    required this.bookContent,
  });

  @override
  List<Object?> get props => [
    bookContentId,
    bookContentTitle,
    bookContent,
  ];
}
