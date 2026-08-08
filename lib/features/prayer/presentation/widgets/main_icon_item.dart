import 'package:flutter/material.dart';

class MainIconItem extends StatelessWidget {
  const MainIconItem({
    super.key,
    required this.iconPath,
    required this.iconColor,
  });

  final String iconPath;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconPath,
      height: 22.5,
      width: 22.5,
      color: iconColor,
    );
  }
}
