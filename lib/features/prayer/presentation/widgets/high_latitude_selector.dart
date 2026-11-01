import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';

class HighLatitudeSelector extends StatelessWidget {
  const HighLatitudeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select<PrayerState, int>(
      (p) => p.highLatitudeMethodIndex,
    );

    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.xSmall,
      children: List.generate(AppStrings.highLatitudeNames.length, (i) {
        return ChoiceChip(
          label: Text(AppStrings.highLatitudeNames[i]),
          selected: selectedIndex == i,
          showCheckmark: true,
          onSelected: (selected) {
            if (!selected) return;
            context.read<PrayerState>().setHighLatitudeIndex = i;
          },
        );
      }),
    );
  }
}
