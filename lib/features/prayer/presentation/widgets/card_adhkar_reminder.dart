import 'package:flutter/material.dart';
import 'package:promus/core/theme/app_paddings.dart';

import '../../../../core/constants/icon_paths.dart';
import '../../../../core/theme/app_shapes.dart';
import 'main_icon_item.dart';

class CardAdhkarReminder extends StatelessWidget {
  const CardAdhkarReminder({
    super.key,
    required this.message,
    required this.routeName,
  });

  final String message;
  final String routeName;

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
        onTap: () {
          // Navigate with route name
        },
        shape: AppShapes.medium,
        splashColor: appColors.secondaryContainer,
        visualDensity: .compact,
        contentPadding: AppPaddings.hrMedium,
        title: Text(message),
        leading: MainIconItem(
          iconPath: IconPaths.iconPathHands,
          iconColor: appColors.secondary,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: appColors.primary,
        ),
      ),
    );
  }
}
