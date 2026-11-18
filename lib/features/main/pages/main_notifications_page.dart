import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_strings.dart';
import '../lists/main_notification_list.dart';
import '../widgets/def_notification_button.dart';

class MainNotificationsPage extends StatelessWidget {
  const MainNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        actions: const [
          DefNotificationButton(),
        ],
      ),
      body: const MainNotificationList(),
    );
  }
}
