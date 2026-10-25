import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_text_styles.dart';

class MainDateCardItem extends StatelessWidget {
  const MainDateCardItem({
    super.key,
    required this.dateText,
    required this.itemColor,
    required this.onTap,
  });

  final String dateText;
  final Color itemColor;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Ink(
      decoration: ShapeDecoration(
        shape: AppShapes.medium,
        gradient: LinearGradient(
          colors: [
            appColors.primaryContainer,
            appColors.tertiaryContainer,
            appColors.secondaryContainer,
          ],
        ),
      ),
      child: ListTile(
        onTap: onTap,
        visualDensity: .compact,
        splashColor: appColors.surfaceDim,
        shape: AppShapes.medium,
        dense: true,
        minVerticalPadding: 0,
        minTileHeight: 0,
        horizontalTitleGap: 8,
        contentPadding: AppPaddings.hrMediumVrSmall,
        title: Text(
          dateText,
          style: AppTextStyles.small,
          overflow: .ellipsis,
        ),
        leading: Icon(
          Icons.calendar_month_rounded,
          color: itemColor,
          size: 17.5,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      ),
    );
  }
}