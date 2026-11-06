import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';

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
        splashColor: appColors.secondaryContainer,
        shape: AppShapes.medium,
        dense: true,
        minVerticalPadding: 0,
        minTileHeight: 0,
        horizontalTitleGap: AppSpacing.small,
        contentPadding: AppPaddings.hrMediumVrSmall,
        title: Text(
          dateText,
          overflow: .ellipsis,
        ),
        leading: Icon(
          Icons.calendar_month_rounded,
          color: itemColor,
          size: AppSpacing.large,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      ),
    );
  }
}
