import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/hizb_entity.dart';
import '../lists/hizb_list.dart';
import '../states/hizb_state.dart';

class HizbPage extends StatelessWidget {
  const HizbPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HizbState, bool>((s) => s.isLoading);
    final error = context.select<HizbState, Object?>((s) => s.error);
    final allHizbs = context.select<HizbState, List<HizbEntity>>(
      (s) => s.hizbs,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Мусхаф',
          style: AppTextStyles.medium,
        ),
      ),
      body: switch ((isLoading, error)) {
        (true, _) => const Center(child: CircularProgressIndicator.adaptive()),
        (_, final e?) => Padding(
          padding: AppPaddings.medium,
          child: Center(child: Text('$e')),
        ),
        _ => HizbList(
          hizbs: allHizbs,
        ),
      },
    );
  }
}
