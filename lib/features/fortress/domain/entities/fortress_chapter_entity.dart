import 'package:equatable/equatable.dart';

class FortressChapterEntity extends Equatable {
  final int chapterId;
  final String chapterNumber;
  final String chapterTitle;

  const FortressChapterEntity({
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
  });

  @override
  List<Object?> get props => [
    chapterId,
    chapterNumber,
    chapterTitle,
  ];
}
