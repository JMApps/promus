import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/icon_paths.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../state/prayer_state.dart';
import 'main_icon_item.dart';

class LastFridayHourCard extends StatelessWidget {
  const LastFridayHourCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isFridayLastHour = context.select<PrayerState, bool>(
          (s) => s.isFridayLastHour,
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
      child: !isFridayLastHour ? const SizedBox.shrink(key: ValueKey('friday-hour-empty')) : Padding(
        key: const ValueKey('friday-hour'),
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
              onTap: null,
              shape: AppShapes.medium,
              splashColor: appColors.secondaryContainer,
              visualDensity: .compact,
              contentPadding: AppPaddings.hrMedium,
              title: const Text(AppStrings.lastFridayHour),
              leading: MainIconItem(
                iconPath: IconPaths.iconPathHands,
                iconColor: appColors.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}