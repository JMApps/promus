import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/icon_paths.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../lists/week_days_row.dart';
import '../widgets/card_additional_times.dart';
import '../widgets/card_adhkar_reminder.dart';
import '../widgets/elapsed_prayer_time_sleek.dart';
import '../widgets/main_city_cupertino_button.dart';
import '../widgets/main_cupertino_button.dart';
import '../widgets/main_date_card_item.dart';
import '../widgets/remaining_prayer_time_sleek.dart';

class MainPrayerPage extends StatelessWidget {
  const MainPrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
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
                Expanded(
                  child: MainCityCupertinoButton(
                    cityText: 'Izmir',
                    onPressed: () {},
                  ),
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathParams,
                  iconColor: appColors.tertiary,
                  onPressed: () {},
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathCalendar,
                  iconColor: appColors.secondary,
                  onPressed: () {},
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathQiblah,
                  iconColor: appColors.secondary,
                  onPressed: () {},
                ),
                MainCupertinoButton(
                  iconPath: IconPaths.iconPathNotifications,
                  iconColor: appColors.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          MainDateCardItem(
            dateText: '26 august 2026',
            itemColor: appColors.primaryContainer,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.small),
          MainDateCardItem(
            dateText: '15 safar 1449',
            itemColor: appColors.secondaryContainer,
            onTap: () {},
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
                      activeStep: 1,
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
                      steps: const [
                        EasyStep(
                          icon: Icon(CupertinoIcons.sparkles),
                          customTitle: Text(
                            '${AppStrings.prayerFajr}\n03:56',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.sun_max_fill),
                          customTitle: Text(
                            '${AppStrings.prayerDhuhr}\n12:41',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.sun_min_fill),
                          customTitle: Text(
                            '${AppStrings.prayerAsr}\n16:28',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.sunset_fill),
                          customTitle: Text(
                            '${AppStrings.prayerMaghrib}\n19:42',
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.moon_stars_fill),
                          customTitle: Text(
                            '${AppStrings.prayerIsha}\n21:16',
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
                          prayerName: 'Название',
                          progress: 0.35,
                          elapsedTime: DateTime.now(),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        RemainingPrayerTimeSleek(
                          prayerName: 'Название',
                          progress: 0.65,
                          remainingTime: DateTime.now(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          CardAdhkarReminder(
            message: 'Время утренних азкаров',
            routeName: '',
          ),
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
                      activeStep: 1,
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
                      steps: const [
                        EasyStep(
                          icon: Icon(CupertinoIcons.sunrise_fill),
                          customTitle: Text(
                            '${AppStrings.sunrise}\n03:56',
                            textAlign: .center,
                          ),
                        ),
                        EasyStep(
                          icon: Icon(CupertinoIcons.moon_fill),
                          customTitle: Text(
                            '${AppStrings.midnight}\n12:41',
                            textAlign: .center,
                          ),
                        ),
                        EasyStep(
                          icon: Icon(Icons.donut_small),
                          customTitle: Text(
                            '${AppStrings.lastThirdNight}\n16:28',
                            textAlign: .center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.large),
                  CardAdditionalTimes(
                    eventName: 'Название',
                    progress: 0.65,
                    remainingTime: DateTime.now(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium * 2),
        ],
      ),
    );
  }
}
