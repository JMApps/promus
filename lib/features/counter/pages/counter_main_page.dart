import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constants/app_strings.dart';
import '../widgets/counter_layout.dart';
import '../widgets/reset_current_count.dart';

class CounterMainPage extends StatelessWidget {
  const CounterMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.titleCounter),
        actions: const [
          ResetCurrentCount(),
        ],
      ),
      body: Padding(
        padding: const .only(bottom: kBottomNavigationBarHeight),
        child: OrientationLayoutBuilder(
          portrait: (_) => const CounterLayout(axis: .vertical),
          landscape: (_) => const CounterLayout(axis: .horizontal),
        ),
      ),
    );
  }
}
