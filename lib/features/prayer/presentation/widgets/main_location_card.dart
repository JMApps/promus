import 'package:flutter/material.dart';

import '../../../../core/constants/icon_paths.dart';
import '../../../../core/routes/names_router.dart';
import 'main_city_cupertino_button.dart';
import 'main_cupertino_button.dart';
import 'qibla_direction.dart';

class MainLocationCard extends StatelessWidget {
  const MainLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Card(
      child: Row(
        children: [
          const Expanded(
            child: MainCityCupertinoButton(),
          ),
          MainCupertinoButton(
            iconPath: IconPaths.iconPathParams,
            iconColor: appColors.secondary,
            onPressed: () => Navigator.pushNamed(
              context,
              NamesRouter.prayerParamsPage,
            ),
          ),
          MainCupertinoButton(
            iconPath: IconPaths.iconPathCalendar,
            iconColor: appColors.primary,
            onPressed: () => Navigator.pushNamed(
              context,
              NamesRouter.monthlyPrayersPage,
            ),
          ),
          MainCupertinoButton(
            iconPath: IconPaths.iconPathQiblah,
            iconColor: appColors.primary,
            onPressed: () => showModalBottomSheet(
              context: context,
              useSafeArea: true,
              builder: (_) => const QiblaDirection(),
            ),
          ),
        ],
      ),
    );
  }
}
