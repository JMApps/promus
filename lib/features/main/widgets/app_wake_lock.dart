import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/main_settings_state.dart';

class AppWakeLock extends StatelessWidget {
  const AppWakeLock({super.key});

  @override
  Widget build(BuildContext context) {
    final enabled = context.select<MainSettingsState, bool>(
      (s) => s.alwaysOnDisplay,
    );
    return SwitchListTile(
      secondary: const Icon(Icons.light_mode_outlined),
      title: const Text(
        AppStrings.alwaysOnDisplay,
        style: AppTextStyles.medium,
      ),
      value: enabled,
      onChanged: context.read<MainSettingsState>().setAlwaysOnDisplay,
    );
  }
}
