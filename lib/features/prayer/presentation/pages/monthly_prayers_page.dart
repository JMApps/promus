import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../lists/monthly_prayers_list.dart';
import '../widgets/monthly_prayers_header.dart';

class MonthlyPrayersPage extends StatelessWidget {
  const MonthlyPrayersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.monthlySchedule),
      ),
      body: const Column(
        children: [
          MonthlyPrayersHeader(),
          Divider(height: AppSpacing.xSmall),
          Expanded(
            child: MonthlyPrayersList(),
          ),
        ],
      ),
    );
  }
}
