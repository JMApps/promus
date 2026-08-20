import 'package:equatable/equatable.dart';

class JuzEntity extends Equatable {
  final int juzNumber;
  final int versesCount;
  final String firstVerseKey;
  final String lastVerseKey;
  final int startPageNumber;

  const JuzEntity({
    required this.juzNumber,
    required this.versesCount,
    required this.firstVerseKey,
    required this.lastVerseKey,
    required this.startPageNumber,
  });

  @override
  List<Object?> get props => [
    juzNumber,
    versesCount,
    firstVerseKey,
    lastVerseKey,
    startPageNumber,
  ];
}
