import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_text_styles.dart';

class CustomChapterCardItem extends StatelessWidget {
  const CustomChapterCardItem({
    super.key,
    required this.title,
    required this.chapterNumber,
  });

  final String title;
  final int chapterNumber;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Card(
      color: appColors.inversePrimary.withAlpha(75),
      elevation: 0,
      shape: AppShapes.medium,
      child: InkWell(
        borderRadius: AppRadius.medium,
        onTap: () {
        },
        child: Padding(
          padding: AppPaddings.medium,
          child: Text(
            title,
            style: AppTextStyles.medium.copyWith(color: appColors.primary),
            textAlign: .center,
            overflow: .ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
