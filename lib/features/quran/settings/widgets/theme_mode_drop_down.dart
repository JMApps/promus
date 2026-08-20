import 'package:flutter/material.dart';

import '../../../../core/enums/app_theme_mode.dart';
import '../../../../core/extensions/app_theme_mode_extension.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';

class ThemeModeDropDown extends StatelessWidget {
  const ThemeModeDropDown({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });

  final String title;
  final int value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final modes = AppThemeMode.values;
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Text(title),
      trailing: DropdownButton<int>(
        borderRadius: AppRadius.medium,
        elevation: 1,
        padding: AppPaddings.withoutRightSmall,
        alignment: Alignment.center,
        value: value,
        items: [
          for (var index = 0; index < modes.length; index++)
            DropdownMenuItem<int>(
              value: index,
              child: Text(
                modes[index].title(context),
                style: TextStyle(
                  fontWeight: value == index ? .bold : .normal,
                ),
                textAlign: .center,
              ),
            ),
        ],
        onChanged: onChanged,
        underline: const SizedBox.shrink(),
      ),
    );
  }
}
