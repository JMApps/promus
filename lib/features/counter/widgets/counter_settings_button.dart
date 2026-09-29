import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class CounterSettingsButton extends StatelessWidget {
  const CounterSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () {},
      tooltip: AppStrings.settings,
      icon: const Icon(Icons.settings),
    );
  }
}
