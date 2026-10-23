import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_radius.dart';
import '../../ayahs/states/ayah_flash_state.dart';

class AyahFlashHighlight extends StatelessWidget {
  const AyahFlashHighlight({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isActive = context.select<AyahFlashState, bool>((s) => s.isActive);
    final color = Theme.of(context).colorScheme.secondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      foregroundDecoration: BoxDecoration(
        color: color.withAlpha(isActive ? 95 : 0),
        borderRadius: AppRadius.medium,
      ),
      child: child,
    );
  }
}