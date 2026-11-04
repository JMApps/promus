import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../state/time_state.dart';
import '../lists/holidays_list.dart';

class DaysToHolidays extends StatelessWidget {
  const DaysToHolidays({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Ink(
      decoration: ShapeDecoration(
        shape: AppShapes.medium,
        gradient: LinearGradient(
          colors: [
            appColors.primaryContainer,
            appColors.tertiaryContainer,
            appColors.secondaryContainer,
          ],
        ),
      ),
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (_) => const SafeArea(
              top: false,
              child: HolidaysList(),
            ),
          );
        },
        shape: AppShapes.medium,
        splashColor: appColors.secondaryContainer,
        visualDensity: .compact,
        contentPadding: AppPaddings.hrMedium,
        title: Selector<TimeState, ({bool isRamadan, int value})>(
          selector: (_, state) {
            final isRamadan = state.isRamadan();
            return (
              isRamadan: isRamadan,
              value: isRamadan
                  ? state.getHijriDateTime.hDay
                  : state.daysUntilHijri(9, 1),
            );
          },
          builder: (_, data, _) => Row(
            children: [
              Expanded(
                child: Text(
                  data.isRamadan
                      ? AppStrings.holyRamadan
                      : AppStrings.daysToRamadan,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              GlassContainer(
                padding: AppPaddings.hrMediumVrSmall,
                child: Text(data.value.toString()),
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 17.5,
        ),
      ),
    );
  }
}
