import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/enums/counter_mode.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/main_counter_state.dart';

class CounterModeSelector extends StatelessWidget {
  const CounterModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Selector<MainCounterState, CounterMode>(
      selector: (_, state) => state.mode,
      builder: (context, currentMode, _) {
        return DropdownButton<CounterMode>(
          padding: AppPaddings.hrSmallVrMedium,
          borderRadius: AppRadius.medium,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          alignment: Alignment.center,
          underline: const SizedBox(),
          value: currentMode,
          items: [
            for (final mode in CounterMode.values)
              DropdownMenuItem<CounterMode>(
                value: mode,
                child: Center(
                  child: Text(
                    AppConstants.tasbeehCounts[mode.index],
                    style: mode == currentMode ? TextStyle(
                      fontSize: 17.0,
                      color: primaryColor,
                      fontWeight: .bold,
                    ) : AppTextStyles.medium,
                    overflow: .ellipsis,
                    textAlign: .center,
                  ),
                ),
              ),
          ],
          onChanged: (mode) {
            if (mode != null) {
              context.read<MainCounterState>().changeMode(mode);
            }
          },
        );
      },
    );
  }
}