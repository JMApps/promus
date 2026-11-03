import 'package:flutter/material.dart';

import '../../../../core/constants/icon_paths.dart';
import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import 'main_icon_item.dart';

class CardAdhkarReminder extends StatelessWidget {
  const CardAdhkarReminder({
    super.key,
    required this.message,
    required this.chapterId,
  });

  final String message;
  final int chapterId;

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
          Navigator.pushNamed(
            context,
            NamesRouter.fortressSupplicationsPage,
            arguments: chapterId,
          );
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
