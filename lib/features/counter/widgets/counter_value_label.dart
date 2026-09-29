import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/font_families.dart';
import '../state/main_counter_state.dart';

class CounterValueLabel extends StatelessWidget {
  const CounterValueLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Text(
      context.watch<MainCounterState>().mainCountValue.toString(),
      style: TextStyle(
        fontFamily: FontFamilies.ptSans,
        fontSize: 85.0,
        color: appColors.primary,
      ),
      textAlign: .center,
    );
  }
}
