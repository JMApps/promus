import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../states/fortress_chapters_state.dart';

class CustomChapterCardItem extends StatelessWidget {
  const CustomChapterCardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.chapterNumber,
    required this.cardColor,
  });

  final IconData icon;
  final String title;
  final int chapterNumber;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Ink(
      decoration: ShapeDecoration(
        shape: AppShapes.medium,
        gradient: LinearGradient(
          begin: .centerLeft,
          colors: [
            appColors.inversePrimary.withAlpha(125),
            appColors.tertiaryContainer.withAlpha(125),
            appColors.secondaryContainer.withAlpha(125),
          ],
        ),
      ),
      child: InkWell(
        borderRadius: AppRadius.medium,
        onTap: () async {
          final chapter = context.read<FortressChapterState>().fortressChapters[chapterNumber - 1];
          await Navigator.pushNamed(
            context,
            NamesRouter.fortressSupplicationsPage,
            arguments: chapter,
          );
        },
        child: Padding(
          padding: AppPaddings.small,
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Icon(icon, color: cardColor),
              const SizedBox(width: AppSpacing.small),
              Text(
                title,
                style: AppTextStyles.medium,
                textAlign: .center,
                overflow: .ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
