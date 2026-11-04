import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/enums/notification_event.dart';
import '../../../core/enums/prayer_labels.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_spacing.dart';
import '../state/notification_settings_state.dart';
import '../widgets/def_notification_button.dart';
import '../widgets/minutes_selector.dart';
import '../widgets/notification_section.dart';
import '../widgets/notification_switch_tile.dart';

class MainNotificationList extends StatelessWidget {
  const MainNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationsState = context.watch<NotificationSettingsState>();

    return ListView(
      padding: AppPaddings.small,
      children: [
        NotificationSection(
          title: AppStrings.prayers,
          children: [
            for (final prayer in PrayerLabels.values)
              NotificationSwitchTile(
                label: prayer.label,
                value: notificationsState.prayerEnabled(prayer),
                onChanged: (v) => notificationsState.setPrayer(prayer, v),
              ),
          ],
        ),
        NotificationSection(
          title: AppStrings.ikamahs,
          children: [
            for (final ikamah in PrayerLabels.withIkamah)
              NotificationSwitchTile(
                label: ikamah.label,
                value: notificationsState.ikamahEnabled(ikamah),
                onChanged: (v) => notificationsState.setIkamah(ikamah, v),
                extra: MinutesSelector(
                  value: notificationsState.ikamahMinutes(ikamah),
                  enabled: notificationsState.ikamahEnabled(ikamah),
                  onChanged: (m) => notificationsState.setIkamahMinutes(ikamah, m),
                ),
              ),
          ],
        ),
        NotificationSection(
          title: AppStrings.fasting,
          children: [
            for (final fast in const [
              NotificationEvent.fastMonday,
              NotificationEvent.fastThursday,
              NotificationEvent.fastWhiteDays,
            ])
              NotificationSwitchTile(
                label: fast.label,
                value: notificationsState.eventEnabled(fast),
                onChanged: (v) => notificationsState.setEvent(fast, v),
              ),
          ],
        ),
        NotificationSection(
          title: AppStrings.friday,
          children: [
            for (final friday in const [
              NotificationEvent.friday,
              NotificationEvent.fridayLastHour,
            ])
              NotificationSwitchTile(
                label: friday.label,
                value: notificationsState.eventEnabled(friday),
                onChanged: (v) => notificationsState.setEvent(friday, v),
              ),
          ],
        ),
        const DefNotificationButton(),
        const SizedBox(height: AppSpacing.medium),
      ],
    );
  }
}
