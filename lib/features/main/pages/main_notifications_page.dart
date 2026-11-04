import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../lists/main_notification_list.dart';

class MainNotificationsPage extends StatelessWidget {
  const MainNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
      ),
      body: const MainNotificationList(),
    );
  }
}
