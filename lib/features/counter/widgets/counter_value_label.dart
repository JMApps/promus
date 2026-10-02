import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/font_families.dart';
import '../state/main_counter_state.dart';

class CounterValueLabel extends StatelessWidget {
  const CounterValueLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final count = context.select<MainCounterState, int>((s) => s.currentCount);
    final isVisible =
    context.select<MainCounterState, bool>((s) => s.countLabelVisible);

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ExcludeSemantics(
        excluding: !isVisible,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamilies.ptSans,
                fontSize: 85.0,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}