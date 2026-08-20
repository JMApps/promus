import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';

class SettingListTileItem extends StatelessWidget {
  const SettingListTileItem({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      visualDensity: .comfortable,
      contentPadding: AppPaddings.hrMedium,
      value: value,
      onChanged: onChanged,
      title: Text(title),
    );
  }
}
