import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/entities/fortress_chapter_entity.dart';

class FortressChapterItem extends StatelessWidget {
  const FortressChapterItem({
    super.key,
    required this.chapterModel,
    required this.index,
  });

  final FortressChapterEntity chapterModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.primary.withAlpha(25);
    final itemEvenColor = appColors.primary.withAlpha(05);
    return ListTile(
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      onTap: () {},
      title: Text(chapterModel.chapterNumber),
      subtitle: Html(
        data: chapterModel.chapterTitle,
        style: {
          '#': Style(
            padding: .zero,
            margin: .zero,
          ),
        },
      ),
    );
  }
}
