import 'package:flutter/material.dart';

import 'app_radius.dart';

class AppShapes {
  AppShapes._();

  static const xSmall  = RoundedRectangleBorder(borderRadius: AppRadius.xSmall);
  static const small  = RoundedRectangleBorder(borderRadius: AppRadius.small);
  static const medium = RoundedRectangleBorder(borderRadius: AppRadius.medium);
  static const large  = RoundedRectangleBorder(borderRadius: AppRadius.large);
}