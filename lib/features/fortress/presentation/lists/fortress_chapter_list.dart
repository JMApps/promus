import 'package:flutter/material.dart';

import '../../domain/entities/fortress_chapter_entity.dart';
import '../items/fortress_chapter_item.dart';

class FortressChapterList extends StatelessWidget {
  const FortressChapterList({
    super.key,
    required this.fortressChapters,
  });

  final List<FortressChapterEntity> fortressChapters;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: fortressChapters.length,
      itemBuilder: (context, index) {
        final chapter = fortressChapters[index];
        return FortressChapterItem(
          fortressChapterModel: chapter,
          index: index,
        );
      },
    );
  }
}
