import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/app_wake_lock.dart';
import '../widgets/theme_color_picker.dart';
import '../widgets/theme_mode_drop_down.dart';

class MainSettingsPage extends StatelessWidget {
  const MainSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        children: const [
          AppWakeLock(),
          Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
          ThemeModeDropDown(),
          Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
          ThemeColorPicker(),
        ],
      ),
    );
  }
}
