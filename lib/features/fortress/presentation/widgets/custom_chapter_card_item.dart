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
    return Card(
      elevation: 0,
      color: cardColor.withAlpha(35),
      shape: AppShapes.medium,
      child: InkWell(
        borderRadius: AppRadius.medium,
        onTap: () async {
          final chapter = context.read<FortressChapterState>().chapters[chapterNumber - 1];
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
