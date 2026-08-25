import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../items/fortress_chapter_item.dart';

class FortressChapterList extends StatelessWidget {
  const FortressChapterList({
    super.key,
    required this.scrollController,
    required this.chapters,
  });

  final ScrollController scrollController;
  final List<FortressChapterEntity> chapters;

  @override
  Widget build(BuildContext context) {
    final double bottomHeight = kBottomNavigationBarHeight + AppSpacing.medium * 2;
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        primary: false,
        padding: .only(bottom: bottomHeight),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return FortressChapterItem(
            chapterModel: chapter,
            index: index,
          );
        },
      ),
    );
  }
}
