import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/city_entity.dart';
import '../../state/prayer_state.dart';

class SelectionCityItem extends StatelessWidget {
  const SelectionCityItem({
    super.key,
    required this.cityModel,
    required this.index,
  });

  final CityEntity cityModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.primary.withAlpha(25);
    final itemEvenColor = appColors.primary.withAlpha(05);
    return Card(
      color: index.isOdd ? itemEvenColor : itemOddColor,
      shape: AppShapes.medium,
      elevation: 0,
      margin: AppPaddings.withoutTopSmall,
      child: ListTile(
        onTap: () {
          showBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: AppPaddings.withoutTopMedium,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      final prayerState = context.read<PrayerState>();
                      final navigator = Navigator.of(context);

                      prayerState.setLocation(
                        country: cityModel.country,
                        city: cityModel.city,
                        latitude: cityModel.latitude,
                        longitude: cityModel.longitude,
                      );

                      navigator..pop()..pop();
                    },
                    child: const Text(
                      AppStrings.select,
                      style: AppTextStyles.medium,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.cancel,
                      style: AppTextStyles.medium.copyWith(
                        color: appColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        horizontalTitleGap: AppSpacing.medium,
        shape: AppShapes.medium,
        contentPadding: AppPaddings.hrMedium,
        title: Text(
          cityModel.city,
          style: AppTextStyles.medium,
        ),
        subtitle: Text(cityModel.country),
        leading: CircleAvatar(
          child: Text(
            cityModel.iso,
            style: AppTextStyles.small,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: AppSpacing.medium,
        ),
      ),
    );
  }
}
