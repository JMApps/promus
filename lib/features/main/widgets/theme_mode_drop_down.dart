import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/main_settings_state.dart';

class ThemeModeDropDown extends StatelessWidget {
  const ThemeModeDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selected = context.select<MainSettingsState, ThemeMode>(
      (s) => s.themeMode,
    );
    final selectedStyle = AppTextStyles.medium.copyWith(
      color: colors.primary,
      fontWeight: .bold,
    );
    return ListTile(
      visualDensity: .comfortable,
      leading: const Icon(Icons.brightness_4_outlined),
      title: const Text(
        AppStrings.theme,
        style: AppTextStyles.medium,
      ),
      trailing: DropdownButton<ThemeMode>(
        value: selected,
        underline: const SizedBox.shrink(),
        alignment: .center,
        elevation: 1,
        borderRadius: AppRadius.medium,
        iconEnabledColor: colors.primary,
        onChanged: (mode) {
          if (mode != null) {
            context.read<MainSettingsState>().setThemeMode(mode);
          }
        },
        items: [
          for (final mode in ThemeMode.values)
            DropdownMenuItem(
              value: mode,
              child: Text(
                mode.label,
                style: mode == selected ? selectedStyle : AppTextStyles.medium,
              ),
            ),
        ],
      ),
    );
  }
}

extension on ThemeMode {
  String get label => switch (this) {
    ThemeMode.system => AppStrings.themeSystem,
    ThemeMode.light => AppStrings.themeLight,
    ThemeMode.dark => AppStrings.themeDark,
  };
}
