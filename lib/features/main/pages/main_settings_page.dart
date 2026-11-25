import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/app_wake_lock.dart';
import '../widgets/hijri_offset_item.dart';
import '../widgets/theme_color_picker.dart';
import '../widgets/theme_mode_drop_down.dart';

class MainSettingsPage extends StatelessWidget {
  const MainSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        children: [
          const Padding(
            padding: AppPaddings.medium,
            child: Text(
              '${AppStrings.appName} | ${AppStrings.appVersion}\nПосвящается Обладателю величия и Почитаемому',
              style: AppTextStyles.small,
            ),
          ),
          const Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
          const AppWakeLock(),
          const Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
          const ThemeModeDropDown(),
          const Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
          const ThemeColorPicker(),
          const Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
          const HijriOffsetItem(),
          const Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
          ListTile(
            title: const Text(AppStrings.licenses),
            onTap: () => showLicensePage(
              context: context,
              applicationName: AppStrings.appName,
              applicationVersion: AppStrings.appVersion,
            ),
          ),
          const Divider(
            indent: AppSpacing.medium,
            endIndent: AppSpacing.medium,
          ),
        ],
      ),
    );
  }
}
