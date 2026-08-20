import 'package:equatable/equatable.dart';

class HizbEntity extends Equatable {
  final int hizbNumber;
  final int versesCount;
  final String firstVerseKey;
  final String lastVerseKey;
  final int startPageNumber;

  const HizbEntity({
    required this.hizbNumber,
    required this.versesCount,
    required this.firstVerseKey,
    required this.lastVerseKey,
    required this.startPageNumber,
  });

  @override
  List<Object?> get props => [
    hizbNumber,
    versesCount,
    firstVerseKey,
    lastVerseKey,
    startPageNumber,
  ];
}
