import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import 'custom_chapter_card_item.dart';

class CustomChaptersList extends StatelessWidget {
  const CustomChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomChapterCardItem(
                icon: CupertinoIcons.sunrise_fill,
                title: AppStrings.morning,
                chapterNumber: 27,
                cardColor: appColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: CustomChapterCardItem(
                icon: CupertinoIcons.sunset_fill,
                title: AppStrings.evening,
                chapterNumber: 28,
                cardColor: appColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        Row(
          children: [
            Expanded(
              child: CustomChapterCardItem(
                icon: CupertinoIcons.moon_fill,
                title: AppStrings.beforeSleep,
                chapterNumber: 29,
                cardColor: appColors.secondary,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: CustomChapterCardItem(
                icon: CupertinoIcons.hand_raised_fill,
                title: AppStrings.afterPrayer,
                chapterNumber: 25,
                cardColor: appColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        CustomChapterCardItem(
          icon: CupertinoIcons.question_circle_fill,
          title: AppStrings.istikhara,
          chapterNumber: 26,
          cardColor: appColors.tertiary,
        ),
      ],
    );
  }
}
