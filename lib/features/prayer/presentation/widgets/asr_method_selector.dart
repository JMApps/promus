import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';

class AsrMethodSelector extends StatelessWidget {
  const AsrMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final selectedIndex = context.select<PrayerState, int>(
      (p) => p.asrMethodIndex,
    );
    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.xSmall,
      children: List.generate(AppStrings.asrMethodNamesList.length, (i) {
        return ChoiceChip(
          label: Text(AppStrings.asrMethodNamesList[i]),
          backgroundColor: appColors.surface,
          selectedColor: selectedIndex == i ? appColors.primaryContainer.withAlpha(75) : appColors.surface,
          selected: selectedIndex == i,
          showCheckmark: false,
          shape: AppShapes.medium,
          side: BorderSide(
            width: selectedIndex == i ? 1.5 : 0.0,
            color: appColors.primary,
          ),
          onSelected: (selected) {
            if (!selected) return;
            context.read<PrayerState>().setAsrMethodIndex = i;
          },
        );
      }),
    );
  }
}
