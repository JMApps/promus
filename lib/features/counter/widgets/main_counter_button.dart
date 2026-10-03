import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../state/main_counter_state.dart';

class MainCounterButton extends StatelessWidget {
  const MainCounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final onCount = context.read<MainCounterState>().onCountClick;
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
              radius: side / 1.95,
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  begin: .topLeft,
                  end: .bottomRight,
                  colors: [
                    appColors.primary,
                    appColors.secondary,
                    appColors.tertiary,
                    appColors.primaryContainer,
                  ],
                ).createShader(bounds),
                child: Icon(
                  Icons.fingerprint_rounded,
                  size: side * 0.95,
                  color: appColors.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
