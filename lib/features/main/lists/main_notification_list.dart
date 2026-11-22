import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/enums/notification_event.dart';
import '../../../core/enums/prayer_labels.dart';
import '../../../core/theme/app_paddings.dart';
import '../../../core/theme/app_spacing.dart';
import '../state/notification_settings_state.dart';
import '../widgets/minutes_selector.dart';
import '../widgets/notification_section.dart';
import '../widgets/notification_switch_tile.dart';

class MainNotificationList extends StatelessWidget {
  const MainNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationsState = context.watch<NotificationSettingsState>();
    final allEnabled = notificationsState.allEnabled;

    return ListView(
      padding: AppPaddings.small,
      children: [
        NotificationSection(
          title: AppStrings.notifications,
          children: [
            NotificationSwitchTile(
              label: AppStrings.allNotifications,
              value: allEnabled,
              onChanged: notificationsState.setAll,
            ),
          ],
        ),
        NotificationSection(
          title: AppStrings.prayers,
          children: [
            for (final prayer in PrayerLabels.withIqamah) ...[
              NotificationSwitchTile(
                label: prayer.label,
                value: notificationsState.prayerEnabled(prayer),
                enabled: allEnabled,
                onChanged: (v) => notificationsState.setPrayer(prayer, v),
              ),
              // Ад-Духа — сразу после Фаджра, в порядке дня.
              if (prayer == PrayerLabels.fajr)
                NotificationSwitchTile(
                  label: NotificationEvent.duha.label,
                  value: notificationsState.eventEnabled(NotificationEvent.duha),
                  enabled: allEnabled,
                  onChanged: (v) => notificationsState.setEvent(NotificationEvent.duha, v),
                ),
            ],
          ],
        ),
        NotificationSection(
          title: AppStrings.iqamahs,
          children: [
            for (final iqamah in PrayerLabels.withIqamah)
              NotificationSwitchTile(
                label: iqamah.label,
                value: notificationsState.iqamahEnabled(iqamah),
                enabled: allEnabled,
                onChanged: (v) => notificationsState.setIqamah(iqamah, v),
                extra: MinutesSelector(
                  value: notificationsState.iqamahMinutes(iqamah),
                  enabled: allEnabled && notificationsState.iqamahEnabled(iqamah),
                  onChanged: (m) => notificationsState.setIqamahMinutes(iqamah, m),
                ),
              ),
          ],
        ),
        NotificationSection(
          title: AppStrings.adhkar,
          children: [
            for (final adhkar in const [
              NotificationEvent.morningAdhkar,
              NotificationEvent.eveningAdhkar,
              NotificationEvent.sleepAdhkar,
            ])
              NotificationSwitchTile(
                label: adhkar.label,
                value: notificationsState.eventEnabled(adhkar),
                enabled: allEnabled,
                onChanged: (v) => notificationsState.setEvent(adhkar, v),
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
                enabled: allEnabled,
                onChanged: (v) => notificationsState.setEvent(fast, v),
              ),
          ],
        ),
        NotificationSection(
          title: AppStrings.friday,
          children: [
            for (final friday in const [
              NotificationEvent.fridayEve,
              NotificationEvent.fridayLastHour,
            ])
              NotificationSwitchTile(
                label: friday.label,
                value: notificationsState.eventEnabled(friday),
                enabled: allEnabled,
                onChanged: (v) => notificationsState.setEvent(friday, v),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
      ],
    );
  }
}