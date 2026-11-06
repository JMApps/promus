import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/icon_paths.dart';
import '../../../../core/routes/names_router.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../state/prayer_state.dart';
import 'main_icon_item.dart';

class MainCityCupertinoButton extends StatelessWidget {
  const MainCityCupertinoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final city = context.select<PrayerState, String>((s) => s.city);
    return CupertinoButton(
      padding: AppPaddings.small,
      onPressed: () {
        Navigator.pushNamed(
          context,
          NamesRouter.selectionCityPage,
        );
      },
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.small),
          MainIconItem(
            iconPath: IconPaths.iconPathLocation,
            iconColor: appColors.tertiary,
          ),
          const SizedBox(width: AppSpacing.small),
          Flexible(
            child: Text(
              city,
              style: AppTextStyles.medium.copyWith(
                color: appColors.tertiary,
              ),
              overflow: .ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
