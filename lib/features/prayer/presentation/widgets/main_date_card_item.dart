import 'package:flutter/material.dart';
import 'package:promus/core/theme/app_paddings.dart';
import 'package:promus/core/theme/app_text_styles.dart';

import '../../../../core/theme/app_shapes.dart';

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
    return Material(
      type: MaterialType.transparency,
      shape: AppShapes.medium,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: ShapeDecoration(
          shape: AppShapes.medium,
          gradient: LinearGradient(
            begin: .topLeft,
            end: .bottomRight,
            colors: [
              appColors.inversePrimary,
              appColors.tertiaryContainer,
              appColors.secondaryContainer,
            ],
          ),
        ),
        child: ListTile(
          onTap: onTap,
          visualDensity: VisualDensity.compact,
          shape: AppShapes.medium,
          dense: true,
          minVerticalPadding: 0,
          minTileHeight: 0,
          horizontalTitleGap: 8,
          contentPadding: AppPaddings.hrMediumVrSmall,
          title: Text(
            dateText,
            style: AppTextStyles.small,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Icon(
            Icons.calendar_month_rounded,
            color: itemColor,
            size: 17.5,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        ),
      ),
    );
  }
}