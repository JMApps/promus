import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../lists/fortress_supplications_list.dart';
import '../states/fortress_chapters_state.dart';
import '../states/fortress_supplications_state.dart';
import '../widgets/main_html_widget.dart';

class VerticalModeSupplicationsPage extends StatefulWidget {
  const VerticalModeSupplicationsPage({
    super.key,
    required this.chapterId,
  });

  final int chapterId;

  @override
  State<VerticalModeSupplicationsPage> createState() => _VerticalModeSupplicationsPageState();
}

class _VerticalModeSupplicationsPageState extends State<VerticalModeSupplicationsPage> {
  late final FortressSupplicationState _fortressSupplicationsState;

  @override
  void initState() {
    super.initState();
    _fortressSupplicationsState = context.read<FortressSupplicationState>();

    if (_fortressSupplicationsState.cachedSupplicationsByChapter(widget.chapterId) != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _fortressSupplicationsState.loadSupplicationsByChapter(
        widget.chapterId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.paddingOf(context).top;
    final isLoading = context.select<FortressSupplicationState, bool>((s) => s.isLoading);
    final error = context.select<FortressSupplicationState, Object?>((s) => s.error);
    final chapter = context.select<FortressChapterState, FortressChapterEntity?>((s) => s.chapterById(widget.chapterId));
    final supplications = context.select<FortressSupplicationState, List<FortressSupplicationEntity>?>((s) => s.cachedSupplicationsByChapter(widget.chapterId));
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
              title: Text(chapter!.chapterNumber),
              actions: [
                IconButton.filledTonal(
                  onPressed: () {
                    _fortressSupplicationsState.changePageMode();
                  },
                  icon: const Icon(Icons.swap_horizontal_circle_rounded),
                ),
              ],
            ),
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
              FortressSupplicationsList(
                fortressChapterSupplications: supplications,
              )
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
