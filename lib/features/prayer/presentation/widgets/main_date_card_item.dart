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
    return ListTile(
      onTap: onTap,
      tileColor: itemColor,
      visualDensity: .compact,
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
      leading: const Icon(
        Icons.calendar_month_rounded,
        size: 17.5,
      ),
      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
    );
  }
}
