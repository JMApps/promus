import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../state/main_counter_state.dart';

class ResetCurrentCount extends StatelessWidget {
  const ResetCurrentCount({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<MainCounterState>().resetCount();
      },
      tooltip: AppStrings.reset,
      icon: const Icon(Icons.refresh_rounded),
    );
  }
}
