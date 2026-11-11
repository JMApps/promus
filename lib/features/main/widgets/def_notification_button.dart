import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/notification_settings_state.dart';

class DefNotificationButton extends StatelessWidget {
  const DefNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await context.read<NotificationSettingsState>().defNotificationValues();
      },
      child: const Text(
        AppStrings.labelDefault,
        style: AppTextStyles.medium,
      ),
    );
  }
}
