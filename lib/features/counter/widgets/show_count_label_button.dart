import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../state/main_counter_state.dart';

class ShowCountLabelButton extends StatelessWidget {
  const ShowCountLabelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isVisible = context.select<MainCounterState, bool>((s) => s.countLabelVisible);
    return IconButton.filledTonal(
      onPressed: context.read<MainCounterState>().toggleCountLabel,
      tooltip: AppStrings.showCountLabel,
      isSelected: isVisible,
      icon: const Icon(Icons.visibility_off_rounded),
      selectedIcon: const Icon(Icons.visibility_rounded),
    );
  }
}