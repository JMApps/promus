import 'package:material_ui/material_ui.dart';

import 'app_spacing.dart';

class AppRadius {
  AppRadius._();

  static const BorderRadius xSmall = .all(Radius.circular(AppSpacing.xSmall));
  static const BorderRadius small = .all(Radius.circular(AppSpacing.small));
  static const BorderRadius medium = .all(Radius.circular(AppSpacing.medium));
  static const BorderRadius large = .all(Radius.circular(AppSpacing.large));
}
