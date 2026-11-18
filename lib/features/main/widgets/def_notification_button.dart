import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../state/notification_settings_state.dart';

class DefNotificationButton extends StatelessWidget {
  const DefNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () async {
        await context.read<NotificationSettingsState>().defNotificationValues();
      },
      tooltip: AppStrings.labelDefault,
      icon: const Icon(Icons.replay),
    );
  }
}
