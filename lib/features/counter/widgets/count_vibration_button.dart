import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../state/main_counter_state.dart';

class CountVibrationButton extends StatelessWidget {
  const CountVibrationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isEnabled =
    context.select<MainCounterState, bool>((s) => s.tacticFeedback);

    return IconButton.filledTonal(
      onPressed: context.read<MainCounterState>().toggleTacticFeedback,
      tooltip: AppStrings.vibration,
      isSelected: isEnabled,
      icon: const Icon(Icons.mobile_off_rounded),
      selectedIcon: const Icon(Icons.vibration_rounded),
    );
  }
}