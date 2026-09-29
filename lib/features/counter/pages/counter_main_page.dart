import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constants/app_strings.dart';
import '../widgets/counter_settings_button.dart';
import '../widgets/counter_value_label.dart';
import '../widgets/main_counter_button.dart';
import '../widgets/reset_current_count.dart';

class CounterMainPage extends StatelessWidget {
  const CounterMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.titleCounter),
        actions: const [
          CounterSettingsButton(),
        ],
      ),
      body: Padding(
        padding: const .only(bottom: kBottomNavigationBarHeight),
        child: Center(
          child: OrientationLayoutBuilder(
            portrait: (context) => const Column(
              mainAxisAlignment: .spaceEvenly,
              children: [
                CounterValueLabel(),
                MainCounterButton(),
                ResetCurrentCount(),
              ],
            ),
            landscape: (context) => const Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                CounterValueLabel(),
                ResetCurrentCount(),
                MainCounterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
