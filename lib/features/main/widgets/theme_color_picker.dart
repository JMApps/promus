import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/main_settings_state.dart';

class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<MainSettingsState>();
    final color = context.select<MainSettingsState, Color>(
      (s) => s.themeColor
    );

    return ListTile(
      leading: const Icon(Icons.color_lens_outlined),
      title: const Text(
        AppStrings.themeColor,
        style: AppTextStyles.medium,
      ),
      trailing: Icon(
        Icons.circle,
        color: color,
        size: 50,
      ),
      onTap: () => showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          alignment: .center,
          actionsPadding: AppPaddings.small,
          title: const Text(
            AppStrings.selectionColor,
            style: AppTextStyles.medium,
          ),
          content: Material(
            color: Colors.transparent,
            child: MaterialColorPicker(
              colors: Colors.primaries,
              allowShades: false,
              alignment: .center,
              iconSelected: Icons.check_circle,
              elevation: 0.5,
              selectedColor: color,
              onMainColorChange: (picked) {
                if (picked is MaterialColor) state.setThemeColor(picked);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
