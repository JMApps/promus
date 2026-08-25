import '../../domain/entities/fortress_chapter_entity.dart';
import '../models/fortress_chapter_model.dart';

extension FortressChapterMapper on FortressChapterModel {
  FortressChapterEntity toEntity() {
    return FortressChapterEntity(
      chapterId: chapterId,
      chapterNumber: chapterNumber,
      chapterTitle: chapterTitle,
    );
  }
}

extension FortressChapterListMapper on List<FortressChapterModel> {
  List<FortressChapterEntity> toEntities() => map((model) => model.toEntity()).toList(growable: false);
}
