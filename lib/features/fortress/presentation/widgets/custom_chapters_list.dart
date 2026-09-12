import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import 'custom_chapter_card_item.dart';

class CustomChaptersList extends StatelessWidget {
  const CustomChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomChapterCardItem(
                title: 'Утром',
                chapterNumber: 27,
              ),
            ),
            SizedBox(width: AppSpacing.small),
            Expanded(
              child: CustomChapterCardItem(
                title: 'Вечером',
                chapterNumber: 28,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.small),
        Row(
          children: [
            Expanded(
              child: CustomChapterCardItem(
                title: 'Перед сном',
                chapterNumber: 29,
              ),
            ),
            SizedBox(width: AppSpacing.small),
            Expanded(
              child: CustomChapterCardItem(
                title: 'После молитвы',
                chapterNumber: 25,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.small),
        CustomChapterCardItem(
          title: 'Истихара',
          chapterNumber: 26,
        ),
      ],
    );
  }
}
