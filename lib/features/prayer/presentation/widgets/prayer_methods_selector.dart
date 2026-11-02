import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';

class PrayerMethodsSelector extends StatelessWidget {
  const PrayerMethodsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final selectedIndex = context.select<PrayerState, int>(
      (p) => p.calculationMethodIndex,
    );
    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.xSmall,
      children: List.generate(AppStrings.prayerCalculationNamesList.length, (i) {
        return ChoiceChip(
          label: Text(AppStrings.prayerCalculationNamesList[i]),
          selected: selectedIndex == i,
          showCheckmark: true,
          shape: AppShapes.medium,
          side: BorderSide(
            width: selectedIndex == i ? 0.75 : 0.0,
            color: appColors.primary,
          ),
          onSelected: (selected) {
            if (!selected) return;
            context.read<PrayerState>().setCalculationIndex = i;
          },
        );
      }),
    );
  }
}
