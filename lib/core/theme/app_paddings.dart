import 'package:flutter/material.dart';

import 'app_spacing.dart';

class AppPaddings {
  static const xSmall = EdgeInsets.all(AppSpacing.xSmall);
  static const small = EdgeInsets.all(AppSpacing.small);
  static const medium = EdgeInsets.all(AppSpacing.medium);
  static const large = EdgeInsets.all(AppSpacing.large);
  static const topMedium = EdgeInsets.only(top: AppSpacing.medium);
  static const withoutTopMedium = EdgeInsets.only(left: AppSpacing.medium, right: AppSpacing.medium, bottom: AppSpacing.medium);
  static const withoutRightSmall = EdgeInsets.only(left: AppSpacing.medium, top: AppSpacing.medium, bottom: AppSpacing.medium);
  static const hrSmallVrLarge = EdgeInsets.symmetric(horizontal: AppSpacing.small, vertical: AppSpacing.large);
  static const hrMedium = EdgeInsets.symmetric(horizontal: AppSpacing.medium);
  static const bottomLarge = EdgeInsets.only(bottom: AppSpacing.large);
  static const rightMedium = EdgeInsets.only(right: AppSpacing.medium);
  static const topMediumSmallOther = EdgeInsets.only(left: AppSpacing.small, top: AppSpacing.large, right: AppSpacing.small, bottom: AppSpacing.medium);
}