import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../lists/fortress_chapter_list.dart';
import '../states/fortress_chapters_state.dart';

class FortressPage extends StatelessWidget {
  const FortressPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<FortressChapterState, bool>((s) => s.isLoading);
    final error = context.select<FortressChapterState, Object?>((s) => s.error);
    final chapters = context.select<FortressChapterState, List<FortressChapterEntity>>(
      (s) => s.chapters,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Крепость'),
        actions: [
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: switch ((isLoading, error)) {
        (true, _) => const Center(child: CircularProgressIndicator.adaptive()),
        (_, final e?) => Padding(
          padding: AppPaddings.medium,
          child: Center(child: Text('$e')),
        ),
        _ => FortressChapterList(
          scrollController: scrollController,
          chapters: chapters,
        ),
      },
    );
  }
}
