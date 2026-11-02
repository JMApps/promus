import 'package:flutter/material.dart';
import 'package:promus/core/theme/app_text_styles.dart';

import '../../../../core/theme/app_paddings.dart';

class PrayerCorrectTile extends StatelessWidget {
  const PrayerCorrectTile({
    super.key,
    required this.label,
    required this.minutes,
    required this.decrementPressed,
    required this.incrementPressed,
  });

  final String label;

  final int minutes;

  final VoidCallback? decrementPressed;
  final VoidCallback? incrementPressed;

  String get minutesText {
    if (minutes > 0) return '+$minutes';
    if (minutes < 0) return '−${minutes.abs()}';
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final isChanged = minutes != 0;

    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: AppPaddings.hrMedium,
      title: Text(
        label,
        style: AppTextStyles.medium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            onPressed: decrementPressed,
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
          SizedBox(
            width: 48,
            child: Text(
              minutesText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isChanged ? appColors.primary : appColors.onSurfaceVariant,
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: incrementPressed,
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}
