import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';

class PrayerMethodsSelector extends StatelessWidget {
  const PrayerMethodsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select<PrayerState, int>(
      (p) => p.calculationMethodIndex,
    );

    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.xSmall,
      children: List.generate(AppStrings.prayerCalculationNames.length, (i) {
        return ChoiceChip(
          label: Text(AppStrings.prayerCalculationNames[i]),
          selected: selectedIndex == i,
          showCheckmark: true,
          onSelected: (selected) {
            if (!selected) return;
            context.read<PrayerState>().setCalculationIndex = i;
          },
        );
      }),
    );
  }
}
