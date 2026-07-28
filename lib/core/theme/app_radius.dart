import 'package:flutter/material.dart';

import 'app_spacing.dart';

class AppRadius {
  AppRadius._();

  static const xSmall  = BorderRadius.all(Radius.circular(AppSpacing.xSmall));
  static const small  = BorderRadius.all(Radius.circular(AppSpacing.small));
  static const medium = BorderRadius.all(Radius.circular(AppSpacing.medium));
  static const large  = BorderRadius.all(Radius.circular(AppSpacing.large));
}