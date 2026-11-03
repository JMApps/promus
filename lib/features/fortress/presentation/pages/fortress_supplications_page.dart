import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../lists/fortress_supplication_list.dart';
import '../states/fortress_chapters_state.dart';
import '../states/fortress_supplications_state.dart';
import '../widgets/main_html_widget.dart';

class FortressSupplicationsPage extends StatefulWidget {
  const FortressSupplicationsPage({
    super.key,
    required this.chapterId,
  });

  final int chapterId;

  @override
  State<FortressSupplicationsPage> createState() => _FortressSupplicationsPageState();
}

class _FortressSupplicationsPageState extends State<FortressSupplicationsPage> {
  @override
  void initState() {
    super.initState();
    final fortressSupplicationsState = context.read<FortressSupplicationState>();

    if (fortressSupplicationsState.cachedSupplicationsByChapter(widget.chapterId) != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      fortressSupplicationsState.loadSupplicationsByChapter(widget.chapterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.paddingOf(context).top;

    final isLoading = context.select<FortressSupplicationState, bool>((s) => s.isLoading);
    final error = context.select<FortressSupplicationState, Object?>((s) => s.error);
    final chapter = context.select<FortressChapterState, FortressChapterEntity?>(
          (s) => s.chapterById(widget.chapterId),
    );
    final supplications = context.select<FortressSupplicationState, List<FortressSupplicationEntity>?>(
          (s) => s.cachedSupplicationsByChapter(widget.chapterId),
    );
    return Scaffold(
      body: RawScrollbar(
        padding: .only(top: topPadding + kToolbarHeight),
        thickness: 2.75,
        thumbColor: appColors.primary.withAlpha(125),
        radius: const .circular(AppSpacing.medium),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              title: Text(chapter?.chapterNumber ?? ''),
            ),
            if (chapter != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppPaddings.topMediumSmallOther,
                  child: Ink(
                    decoration: ShapeDecoration(
                      shape: AppShapes.medium,
                      gradient: LinearGradient(
                        begin: .centerLeft,
                        colors: [
                          appColors.inversePrimary,
                          appColors.tertiaryContainer,
                          appColors.secondaryContainer,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: AppPaddings.small,
                      child: MainHtmlWidget(
                        htmlContent: chapter.chapterTitle,
                        textAlign: .center,
                      ),
                    ),
                  ),
                ),
              ),
            if (supplications != null)
              FortressSupplicationList(fortressChapterSupplications: supplications)
            else if (error != null && !isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(AppStrings.errorLoadData),
                ),
              )
            else
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
