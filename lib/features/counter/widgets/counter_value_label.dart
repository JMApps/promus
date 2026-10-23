import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/main_counter_state.dart';

class CounterValueLabel extends StatelessWidget {
  const CounterValueLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final count = context.select<MainCounterState, int>(
      (s) => s.currentCount,
    );
    final isVisible = context.select<MainCounterState, bool>(
      (s) => s.countLabelVisible,
    );
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ExcludeSemantics(
        excluding: !isVisible,
        child: Padding(
          padding: AppPaddings.hrMedium,
          child: FittedBox(
            fit: .scaleDown,
            child: Text(
              count.toString(),
              textAlign: .center,
              style: AppTextStyles.medium.copyWith(
                color: appColors.secondary,
                fontSize: 100.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
