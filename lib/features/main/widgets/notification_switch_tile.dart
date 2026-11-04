import 'package:flutter/material.dart';

import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_shapes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class NotificationSwitchTile extends StatelessWidget {
  const NotificationSwitchTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.extra,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: .compact,
      shape: AppShapes.medium,
      contentPadding: AppPaddings.hrMedium,
      title: Text(
        label,
        style: AppTextStyles.medium,
        maxLines: 1,
        overflow: .ellipsis,
      ),
      trailing: Row(
        mainAxisSize: .min,
        children: [
          if (extra != null) ...[
            extra!,
            const SizedBox(width: AppSpacing.medium),
          ],
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
