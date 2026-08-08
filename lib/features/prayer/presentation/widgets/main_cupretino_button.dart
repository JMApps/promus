import 'package:flutter/cupertino.dart';
import 'package:promus/core/theme/app_paddings.dart';

class MainCupertinoButton extends StatelessWidget {
  const MainCupertinoButton({
    super.key,
    required this.iconPath,
    required this.iconColor,
    required this.onPressed,
  });

  final String iconPath;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: AppPaddings.rightMedium,
      onPressed: onPressed,
      child: Image.asset(
        iconPath,
        height: 22.5,
        width: 22.5,
        color: iconColor,
      ),
    );
  }
}
