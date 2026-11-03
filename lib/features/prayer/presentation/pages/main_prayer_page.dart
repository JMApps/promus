import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/icon_paths.dart';
import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/prayer_state.dart';
import '../lists/week_days_row.dart';
import '../widgets/card_additional_times.dart';
import '../widgets/card_adhkar_reminder.dart';
import '../widgets/days_to_holidays.dart';
import '../widgets/elapsed_prayer_time_sleek.dart';
import '../widgets/gregorian_date_picker.dart';
import '../widgets/hijri_date_picker.dart';
import '../widgets/main_city_cupertino_button.dart';
import '../widgets/main_cupertino_button.dart';
import '../widgets/main_date_card_item.dart';
import '../widgets/main_icon_item.dart';
import '../widgets/qibla_direction.dart';
import '../widgets/remaining_prayer_time_sleek.dart';

class MainPrayerPage extends StatelessWidget {
  const MainPrayerPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final prayer = context.watch<PrayerState>();
    final adhkarMessage = prayer.adhkarMessage;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: false,
        actions: [
          CupertinoButton(
            padding: .zero,
            child: MainIconItem(
              iconPath: IconPaths.iconPathSetting,
              iconColor: appColors.primary,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                NamesRouter.mainSettingsPage,
              );
            },
          ),
          // CupertinoButton(
          //   padding: const .only(right: AppSpacing.medium),
          //   child: MainIconItem(
          //     iconPath: IconPaths.iconPathLibrary,
          //     iconColor: appColors.primary,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const .only(
          left: AppSpacing.small,
          right: AppSpacing.small,
          bottom: kBottomNavigationBarHeight + AppSpacing.small,
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Card(
              child: Row(
                children: [
                  const Expanded(
                    child: MainCityCupertinoButton(),
                  ),
                  MainCupertinoButton(
                    iconPath: IconPaths.iconPathParams,
                    iconColor: appColors.secondary,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NamesRouter.prayerParamsPage,
                      );
                    },
                  ),
                  MainCupertinoButton(
                    iconPath: IconPaths.iconPathCalendar,
                    iconColor: appColors.primary,
                    onPressed: () {},
                  ),
                  MainCupertinoButton(
                    iconPath: IconPaths.iconPathQiblah,
                    iconColor: appColors.primary,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        builder: (_) {
                          return const QiblaDirection();
                        },
                      );
                    },
                  ),
                  MainCupertinoButton(
                    iconPath: IconPaths.iconPathNotifications,
                    iconColor: appColors.primary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            MainDateCardItem(
              dateText: prayer.gregorianDateText,
              itemColor: appColors.primary,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => const GregorianDatePicker(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.small),
            MainDateCardItem(
              dateText: prayer.hijriDateText,
              itemColor: appColors.tertiary,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => const HijriDatePicker(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.small),
            WeekDaysRow(weekDay: DateTime.now().weekday),
            const SizedBox(height: AppSpacing.small),
            Card(
              child: Padding(
                padding: AppPaddings.medium,
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Flexible(
                      child: EasyStepper(
                        verticalAlignment: .start,
                        activeStep: prayer.currentPrayerStep,
                        direction: .vertical,
                        showTitle: true,
                        showLoadingAnimation: false,
                        stepRadius: AppSpacing.large,
                        finishedStepBackgroundColor: appColors.primary,
                        activeStepBackgroundColor: appColors.tertiary,
                        unreachedStepBorderColor: appColors.secondaryContainer,
                        activeStepBorderColor: Colors.transparent,
                        unreachedStepIconColor: appColors.secondaryContainer,
                        activeStepIconColor: appColors.primaryContainer,
                        borderThickness: 3.5,
                        activeStepBorderType: .normal,
                        unreachedStepBorderType: .normal,
                        lineStyle: const LineStyle(
                          lineType: .dotted,
                          unreachedLineType: .dotted,
                        ),
                        steps: [
                          EasyStep(
                            icon: const Icon(CupertinoIcons.sparkles),
                            customTitle: Text(
                              '${AppStrings.prayerFajr}\n${prayer.formatTime(prayer.prayerTimes.fajr)}',
                            ),
                          ),
                          EasyStep(
                            icon: const Icon(CupertinoIcons.sun_max_fill),
                            customTitle: Text(
                              '${AppStrings.prayerDhuhr}\n${prayer.formatTime(prayer.prayerTimes.dhuhr)}',
                            ),
                          ),
                          EasyStep(
                            icon: const Icon(CupertinoIcons.sun_min_fill),
                            customTitle: Text(
                              '${AppStrings.prayerAsr}\n${prayer.formatTime(prayer.prayerTimes.asr)}',
                            ),
                          ),
                          EasyStep(
                            icon: const Icon(CupertinoIcons.sunset_fill),
                            customTitle: Text(
                              '${AppStrings.prayerMaghrib}\n${prayer.formatTime(prayer.prayerTimes.maghrib)}',
                            ),
                          ),
                          EasyStep(
                            icon: const Icon(CupertinoIcons.moon_stars_fill),
                            customTitle: Text(
                              '${AppStrings.prayerIsha}\n${prayer.formatTime(prayer.prayerTimes.isha)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          ElapsedPrayerTimeSleek(
                            prayerName: prayer.elapsed.name,
                            progress: prayer.elapsed.progress,
                            timeText: prayer.elapsed.timeText,
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          RemainingPrayerTimeSleek(
                            prayerName: prayer.remaining.name,
                            progress: prayer.remaining.progress,
                            timeText: prayer.remaining.timeText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (adhkarMessage != null) ...[
              const SizedBox(height: AppSpacing.medium),
            ],
            if (adhkarMessage != null) ...[
              CardAdhkarReminder(
                message: adhkarMessage,
                routeName: '',
              ),
            ],
            const SizedBox(height: AppSpacing.medium),
            Card(
              child: Padding(
                padding: AppPaddings.mediumBottomSmall,
                child: Row(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [
                    Flexible(
                      child: EasyStepper(
                        verticalAlignment: .start,
                        activeStep: prayer.currentEventStep,
                        direction: .horizontal,
                        showTitle: true,
                        showLoadingAnimation: false,
                        stepRadius: AppSpacing.large,
                        finishedStepBackgroundColor: appColors.primary,
                        activeStepBackgroundColor: appColors.tertiary,
                        unreachedStepBorderColor: appColors.secondaryContainer,
                        activeStepBorderColor: Colors.transparent,
                        unreachedStepIconColor: appColors.secondaryContainer,
                        activeStepIconColor: appColors.primaryContainer,
                        borderThickness: 3.5,
                        activeStepBorderType: .normal,
                        unreachedStepBorderType: .normal,
                        lineStyle: const LineStyle(
                          lineLength: .infinity,
                          lineType: .dotted,
                          unreachedLineType: .dotted,
                        ),
                        steps: [
                          EasyStep(
                            icon: const Icon(CupertinoIcons.sunrise_fill),
                            customTitle: Text(
                              '${AppStrings.sunrise}\n${prayer.formatTime(prayer.prayerTimes.sunrise)}',
                              textAlign: .center,
                            ),
                          ),
                          EasyStep(
                            icon: const Icon(CupertinoIcons.moon_fill),
                            customTitle: Text(
                              '${AppStrings.midnight}\n${prayer.formatTime(prayer.sunnahTimes.middleOfTheNight)}',
                              textAlign: .center,
                            ),
                          ),
                          EasyStep(
                            icon: const Icon(Icons.donut_small),
                            customTitle: Text(
                              '${AppStrings.lastThirdNight}\n${prayer.formatTime(prayer.sunnahTimes.lastThirdOfTheNight)}',
                              textAlign: .center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.large),
                    CardAdditionalTimes(
                      eventName: prayer.event.name,
                      progress: prayer.event.progress,
                      timeText: prayer.event.timeText,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            const DaysToHolidays(),
            const SizedBox(height: AppSpacing.medium * 1.75),
          ],
        ),
      ),
    );
  }
}
