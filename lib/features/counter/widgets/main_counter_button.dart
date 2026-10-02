import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../state/main_counter_state.dart';

class MainCounterButton extends StatelessWidget {
  const MainCounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final onCount = context.read<MainCounterState>().onCountClick;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;

        return Center(
          child: Semantics(
            button: true,
            label: AppStrings.titleCounter,
            onTap: onCount,
            child: InkResponse(
              onTapDown: (_) => onCount(),
              radius: side / 2,
              child: Icon(
                Icons.fingerprint_rounded,
                size: side * 0.85,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}