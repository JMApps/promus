import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/font_families.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../state/prayer_state.dart';

class FridaySalawahCard extends StatelessWidget {
  const FridaySalawahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isFriday = context.select<PrayerState, bool>(
      (s) => s.isFriday,
    );
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
      child: !isFriday ? const SizedBox.shrink(key: ValueKey('friday-hour-empty')) : const Card(
        margin: AppPaddings.topMedium,
        elevation: 0,
        child: Padding(
          padding: AppPaddings.medium,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppStrings.ayahFridayAr,
                  style: TextStyle(
                    fontFamily: FontFamilies.uthmanic,
                    letterSpacing: 0,
                    fontSize: 17.0,
                    height: 1.8,
                  ),
                ),
                TextSpan(text: '\n'),
                TextSpan(
                  text: AppStrings.ayahFridayRu,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            textAlign: .center,
          ),
        ),
      ),
    );
  }
}
