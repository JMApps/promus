import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/juz_entity.dart';
import '../lists/juz_list.dart';
import '../states/juz_state.dart';
import '../widgets/to_hizb_list_button.dart';

class JuzPage extends StatelessWidget {
  const JuzPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<JuzState, bool>((s) => s.isLoading);
    final error = context.select<JuzState, Object?>((s) => s.error);
    final juzs = context.select<JuzState, List<JuzEntity>>((s) => s.juzs);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Джузы',
          style: AppTextStyles.medium,
        ),
        actions: const [
          ToHizbsPageButton(),
        ],
      ),
      body: switch ((isLoading, error)) {
        (true, _) => const Center(child: CircularProgressIndicator.adaptive()),
        (_, final e?) => Padding(
          padding: AppPaddings.medium,
          child: Center(child: Text('$e')),
        ),
        _ => JuzList(
          scrollController: scrollController,
          juzs: juzs,
        ),
      },
    );
  }
}
