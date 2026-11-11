import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/adhkar_reminders.dart';
import '../../../../core/constants/icon_paths.dart';
import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../state/prayer_state.dart';
import 'main_icon_item.dart';

class AdhkarReminderSection extends StatelessWidget {
  const AdhkarReminderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final adhkarMessage = context.select<PrayerState, AdhkarReminder?>(
          (s) => s.adhkarReminder,
    );
    final appColors = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
           axisAlignment: -1,
          child: child,
        ),
      ),
      layoutBuilder: (current, previous) => Stack(
        alignment: .topCenter,
        children: [...previous, ?current],
      ),
      child: adhkarMessage == null ? const SizedBox.shrink(key: ValueKey('adhkar-empty')) : Padding(
        key: ValueKey(adhkarMessage.message),
        padding: AppPaddings.topMedium,
        child: Material(
          type: .transparency,
          child: Ink(
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
              onTap: () => Navigator.pushNamed(
                context,
                NamesRouter.fortressSupplicationsPage,
                arguments: adhkarMessage.chapterId,
              ),
              shape: AppShapes.medium,
              splashColor: appColors.secondaryContainer,
              visualDensity: .compact,
              contentPadding: AppPaddings.hrMedium,
              title: Text(adhkarMessage.message),
              leading: MainIconItem(
                iconPath: IconPaths.iconPathHands,
                iconColor: appColors.secondary,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: appColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}