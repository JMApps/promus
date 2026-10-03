import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_shapes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/main_counter_state.dart';

class ResetCurrentCount extends StatelessWidget {
  const ResetCurrentCount({super.key});

  void _reset(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final state = context.read<MainCounterState>();
    final mode = state.mode;
    final previous = state.resetCurrent();
    if (previous == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: .floating,
          content: Text(
            AppStrings.countReset,
            style: AppTextStyles.medium.copyWith(color: appColors.onPrimary),
          ),
          duration: const Duration(seconds: 5),
          persist: false,
          backgroundColor: appColors.primary,
          shape: AppShapes.medium,
          margin: AppPaddings.small,
          action: SnackBarAction(
            textColor: appColors.inversePrimary,
            label: AppStrings.undo,
            onPressed: () => state.setValue(mode, previous),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () => _reset(context),
      tooltip: AppStrings.reset,
      icon: const Icon(Icons.refresh_rounded),
    );
  }
}
