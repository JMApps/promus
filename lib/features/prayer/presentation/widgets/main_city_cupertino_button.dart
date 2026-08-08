import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/icon_paths.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'main_icon_item.dart';

class MainCityCupertinoButton extends StatelessWidget {
  const MainCityCupertinoButton({
    super.key,
    required this.cityText,
    required this.onPressed,
  });

  final String cityText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return CupertinoButton(
      padding: AppPaddings.small,
      onPressed: onPressed,
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.small),
          MainIconItem(
            iconPath: IconPaths.iconPathLocation,
            iconColor: appColors.error,
          ),
          const SizedBox(width: AppSpacing.small),
          Flexible(
            child: Text(
              'Izmir',
              style: AppTextStyles.medium.copyWith(color: appColors.secondary),
              overflow: .ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
