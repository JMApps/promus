import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constants/app_strings.dart';
import '../widgets/count_vibration_button.dart';
import '../widgets/counter_mode_selector.dart';
import '../widgets/counter_value_label.dart';
import '../widgets/main_counter_button.dart';
import '../widgets/reset_current_count.dart';
import '../widgets/show_count_label_button.dart';

class CounterMainPage extends StatelessWidget {
  const CounterMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.titleCounter),
        actions: const [ResetCurrentCount()],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: OrientationLayoutBuilder(
          portrait: (_) => const _CounterLayout(axis: Axis.vertical),
          landscape: (_) => const _CounterLayout(axis: Axis.horizontal),
        ),
      ),
    );
  }
}

class _CounterLayout extends StatelessWidget {
  const _CounterLayout({required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final controlsAxis =
    axis == Axis.vertical ? Axis.horizontal : Axis.vertical;

    return Flex(
      direction: axis,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Flexible(flex: 2, child: CounterValueLabel()),
        const Expanded(flex: 5, child: MainCounterButton()),
        _Controls(axis: controlsAxis),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      mainAxisSize:
      axis == Axis.horizontal ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        ShowCountLabelButton(),
        CounterModeSelector(),
        CountVibrationButton(),
      ],
    );
  }
}