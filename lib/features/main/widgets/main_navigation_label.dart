import 'package:flutter/material.dart';

import '../../../core/constants/font_families.dart';

class MainNavigationLabel extends StatelessWidget {
  const MainNavigationLabel({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: FontFamilies.ptSans,
      ),
    );
  }
}
