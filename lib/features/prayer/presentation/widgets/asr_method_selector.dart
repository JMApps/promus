import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';

class AsrMethodSelector extends StatelessWidget {
  const AsrMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select<PrayerState, int>(
      (p) => p.asrMethodIndex,
    );

    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.xSmall,
      children: List.generate(AppStrings.asrMethodNames.length, (i) {
        return ChoiceChip(
          label: Text(AppStrings.asrMethodNames[i]),
          selected: selectedIndex == i,
          showCheckmark: true,
          onSelected: (selected) {
            if (!selected) return;
            context.read<PrayerState>().setAsrMethodIndex = i;
          },
        );
      }),
    );
  }
}
