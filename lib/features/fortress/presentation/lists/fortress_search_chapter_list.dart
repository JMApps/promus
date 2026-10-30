import 'package:flutter/material.dart';

import '../../../other/widgets/search_is_empty_widget.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../items/fortress_chapter_item.dart';

class FortressSearchChapterList extends StatelessWidget {
  const FortressSearchChapterList({
    super.key,
    required this.chapters,
  });

  final List<FortressChapterEntity> chapters;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const SearchIsEmptyWidget();
    }

    return Scrollbar(
      child: ListView.builder(
        padding: .zero,
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          return FortressChapterItem(
            fortressChapterModel: chapters[index],
            index: index,
          );
        },
      ),
    );
  }
}
