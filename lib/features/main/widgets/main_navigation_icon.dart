import 'package:flutter/material.dart';

class MainNavigationIcon extends StatelessWidget {
  const MainNavigationIcon({
    super.key,
    required this.iconPath,
  });

  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Image.asset(
      iconPath,
      height: 25.0,
      width: 25.0,
      color: appColors.primary,
    );
  }
}
