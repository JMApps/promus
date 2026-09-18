import 'package:flutter/material.dart';

import '../../domain/entities/fortress_chapter_entity.dart';
import '../items/fortress_chapter_item.dart';

class FortressChapterList extends StatelessWidget {
  const FortressChapterList({
    super.key,
    required this.chapters,
  });

  final List<FortressChapterEntity> chapters;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return FortressChapterItem(
          chapterModel: chapter,
          index: index,
        );
      },
    );
  }
}