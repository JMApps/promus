import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/icon_paths.dart';
import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../lists/week_days_row.dart';
import '../widgets/adhkar_reminder_section.dart';
import '../widgets/days_to_holidays.dart';
import '../widgets/events_card.dart';
import '../widgets/gregorian_date_card.dart';
import '../widgets/hijri_date_card.dart';
import '../widgets/main_icon_item.dart';
import '../widgets/main_location_card.dart';
import '../widgets/prayers_card.dart';

class MainPrayerPage extends StatelessWidget {
  const MainPrayerPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: false,
        actions: [
          IconButton.filledTonal(
            onPressed: () => Navigator.pushNamed(
              context,
              NamesRouter.mainNotificationsPage,
            ),
            tooltip: AppStrings.notifications,
            icon: MainIconItem(
              iconPath: IconPaths.iconPathNotifications,
              iconColor: appColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          IconButton.filledTonal(
            onPressed: () => Navigator.pushNamed(
              context,
              NamesRouter.mainSettingsPage,
            ),
            tooltip: AppStrings.settings,
            icon: MainIconItem(
              iconPath: IconPaths.iconPathSetting,
              iconColor: appColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.small),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const .only(
          top: AppSpacing.small,
          left: AppSpacing.small,
          right: AppSpacing.small,
          bottom: kBottomNavigationBarHeight + AppSpacing.small,
        ),
        child: const Column(
          crossAxisAlignment: .stretch,
          children: [
            MainLocationCard(),
            SizedBox(height: AppSpacing.medium),
            GregorianDateCard(),
            SizedBox(height: AppSpacing.small),
            HijriDateCard(),
            SizedBox(height: AppSpacing.medium),
            WeekDaysRow(),
            SizedBox(height: AppSpacing.medium),
            PrayersCard(),
            AdhkarReminderSection(),
            SizedBox(height: AppSpacing.medium),
            EventsCard(),
            SizedBox(height: AppSpacing.medium),
            DaysToHolidays(),
            SizedBox(height: AppSpacing.medium * 1.85),
          ],
        ),
      ),
    );
  }
}
