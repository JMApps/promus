import 'package:flutter/material.dart';

import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../widgets/main_html_widget.dart';

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
    return Card(
      margin: AppPaddings.withoutTopSmall,
      elevation: 0,
      color: index.isOdd ? itemEvenColor : itemOddColor,
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            NamesRouter.fortressSupplicationsPage,
            arguments: chapterModel,
          );
        },
        horizontalTitleGap: 8,
        shape: AppShapes.medium,
        contentPadding: AppPaddings.hrMedium,
        title: MainHtmlWidget(
          htmlContent: chapterModel.chapterTitle,
          textAlign: .start,
        ),
        leading: CircleAvatar(
          radius: 17.5,
          backgroundColor: appColors.inversePrimary,
          child: Text(
            chapterModel.chapterId.toString(),
            style: AppTextStyles.small.copyWith(
              fontSize: 14.0,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: AppSpacing.medium,
        ),
      ),
    );
  }
}
