import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';

class PrayerParamsPage extends StatelessWidget {
  const PrayerParamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.params),
      ),
      body: const SingleChildScrollView(
        padding: AppPaddings.medium,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [],
        ),
      ),
    );
  }
}
