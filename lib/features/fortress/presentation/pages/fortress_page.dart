import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../lists/fortress_chapter_list.dart';
import '../states/fortress_chapters_state.dart';
import '../widgets/custom_chapters_list.dart';

class FortressPage extends StatelessWidget {
  const FortressPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final isLoading = context.select<FortressChapterState, bool>((s) => s.isLoading);
    final error = context.select<FortressChapterState, Object?>((s) => s.error);
    final chapters = context.select<FortressChapterState, List<FortressChapterEntity>>(
      (s) => s.chapters,
    );
    return Scaffold(
      body: switch ((isLoading, error)) {
        (true, _) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        (_, final e?) => Padding(
          padding: AppPaddings.medium,
          child: Center(
            child: Text(
              '$e',
              style: TextStyle(
                color: appColors.error,
              ),
            ),
          ),
        ),
        _ => CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              centerTitle: false,
              title: const Text(AppStrings.titleFortress),
              actions: [
                IconButton.filledTonal(
                  onPressed: () {
                    // Search chapters
                  },
                  tooltip: AppStrings.searchByChapters,
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: AppPaddings.withoutBottomSmall,
                    child: CustomChaptersList(),
                  ),
                  Divider(
                    indent: AppSpacing.medium,
                    endIndent: AppSpacing.medium,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: FortressChapterList(
                scrollController: scrollController,
                chapters: chapters,
              ),
            ),
          ],
        ),
      },
    );
  }
}
