import 'package:flutter/material.dart';

import 'count_vibration_button.dart';
import 'counter_mode_selector.dart';
import 'counter_value_label.dart';
import 'main_counter_button.dart';
import 'show_count_label_button.dart';

class CounterLayout extends StatelessWidget {
  const CounterLayout({
    super.key,
    required this.axis,
  });

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final controlsAxis = axis == .vertical ? Axis.horizontal : Axis.vertical;
    return Flex(
      direction: axis,
      mainAxisAlignment: .spaceEvenly,
      children: [
        const Flexible(
          child: CounterValueLabel(),
        ),
        const Expanded(
          child: MainCounterButton(),
        ),
        Flex(
          direction: controlsAxis,
          mainAxisSize: .max,
          mainAxisAlignment: .spaceEvenly,
          children: const [
            ShowCountLabelButton(),
            CounterModeSelector(),
            CountVibrationButton(),
          ],
        ),
      ],
    );
  }
}
