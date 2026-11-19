import 'package:material_ui/material_ui.dart';

import 'app_spacing.dart';

class AppPaddings {
  static const EdgeInsets xSmall = .all(AppSpacing.xSmall);
  static const EdgeInsets small = .all(AppSpacing.small);
  static const EdgeInsets medium = .all(AppSpacing.medium);
  static const EdgeInsets large = .all(AppSpacing.large);
  static const EdgeInsets topMedium = .only(top: AppSpacing.medium);
  static const EdgeInsets withoutTopMedium = .only(
    left: AppSpacing.medium,
    right: AppSpacing.medium,
    bottom: AppSpacing.medium,
  );

  static const EdgeInsets withoutTopSmallBottomMedium = .only(
    left: AppSpacing.small,
    right: AppSpacing.small,
    bottom: AppSpacing.medium,
  );

  static const EdgeInsets withoutTopSmall = .only(
    left: AppSpacing.small,
    right: AppSpacing.small,
    bottom: AppSpacing.small,
  );

  static const EdgeInsets withoutTopLeftMediumOtherSmall = .only(
    left: AppSpacing.medium,
    right: AppSpacing.small,
    bottom: AppSpacing.small,
  );

  static const EdgeInsets withoutBottomMedium = .only(
    left: AppSpacing.medium,
    top: AppSpacing.medium,
    right: AppSpacing.medium,
  );
  static const EdgeInsets withoutBottomSmall = .only(
    left: AppSpacing.small,
    top: AppSpacing.small,
    right: AppSpacing.small,
  );
  static const EdgeInsets mediumBottomSmall = .only(
    left: AppSpacing.medium,
    top: AppSpacing.medium,
    right: AppSpacing.medium,
    bottom: AppSpacing.small,
  );
  static const EdgeInsets withoutRightSmall = .only(
    left: AppSpacing.medium,
    top: AppSpacing.medium,
    bottom: AppSpacing.medium,
  );
  static const EdgeInsets hrSmallVrLarge = .symmetric(
    horizontal: AppSpacing.small,
    vertical: AppSpacing.large,
  );
  static const EdgeInsets hrSmallVrMedium = .symmetric(
    horizontal: AppSpacing.small,
    vertical: AppSpacing.medium,
  );
  static const EdgeInsets hrMediumVrXSmall = .symmetric(
    horizontal: AppSpacing.medium,
    vertical: AppSpacing.xSmall,
  );
  static const EdgeInsets hrMediumVrSmall = .symmetric(
    horizontal: AppSpacing.medium,
    vertical: AppSpacing.small,
  );
  static const EdgeInsets verticalSmall = .symmetric(
    vertical: AppSpacing.small,
  );
  static const EdgeInsets hrMedium = .symmetric(horizontal: AppSpacing.medium);
  static const EdgeInsets hrSmall = .symmetric(horizontal: AppSpacing.small);
  static const EdgeInsets bottomLarge = .only(bottom: AppSpacing.large);
  static const EdgeInsets bottomMedium = .only(bottom: AppSpacing.medium);
  static const EdgeInsets bottomSmall = .only(bottom: AppSpacing.small);
  static const EdgeInsets rightMedium = .only(right: AppSpacing.medium);
  static const EdgeInsets leftXSmall = .only(left: AppSpacing.xSmall);
  static const EdgeInsets leftMedium = .only(left: AppSpacing.medium);
  static const EdgeInsets topMediumSmallOther = .only(
    left: AppSpacing.small,
    top: AppSpacing.large,
    right: AppSpacing.small,
    bottom: AppSpacing.medium,
  );
}
