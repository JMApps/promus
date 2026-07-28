import 'package:flutter/material.dart';

import '../constants/font_families.dart';

class AppTextStyles {
  AppTextStyles._();

  static const small = TextStyle(
    fontSize: 12,
    fontFamily: FontFamilies.ptSans,
  );

  static const medium = TextStyle(
    fontSize: 17,
    fontFamily: FontFamilies.ptSans,
  );

  static const large = TextStyle(
    fontSize: 24,
    fontFamily: FontFamilies.ptSans,
  );
}
