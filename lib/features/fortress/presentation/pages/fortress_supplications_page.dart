import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../lists/fortress_horizontal_supplications_list.dart';
import '../lists/fortress_supplications_list.dart';
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
  late final FortressSupplicationState _fortressSupplicationsState;
  late final PageController _supplicationPageController;

  @override
  void initState() {
    super.initState();
    _fortressSupplicationsState = context.read<FortressSupplicationState>();
    _supplicationPageController = PageController();

    if (_fortressSupplicationsState.cachedSupplicationsByChapter(widget.chapterId) != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fortressSupplicationsState.loadSupplicationsByChapter(widget.chapterId);
    });
  }

  @override
  void dispose() {
    _supplicationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.paddingOf(context).top;
    final isLoading = context.select<FortressSupplicationState, bool>((s) => s.isLoading);
    final error = context.select<FortressSupplicationState, Object?>((s) => s.error);
    final pageMode = context.select<FortressSupplicationState, bool>((s) => s.pageMode);
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
              pinned: pageMode,
              title: Text(chapter!.chapterNumber),
              actions: [
                IconButton.filledTonal(
                  onPressed: () {
                    _fortressSupplicationsState.changePageMode();
                  },
                  isSelected: pageMode,
                  selectedIcon: const Icon(Icons.swap_vertical_circle_rounded),
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
              pageMode ? SliverFillRemaining(
                child: Column(
                  children: [
                    Expanded(
                      child: FortressHorizontalSupplicationsList(
                        controller: _supplicationPageController,
                        fortressChapterSupplications: supplications,
                      ),
                    ),
                    Padding(
                      padding: AppPaddings.medium,
                      child: SmoothPageIndicator(
                        controller: _supplicationPageController,
                        count: supplications.length,
                        effect: ScrollingDotsEffect(
                          maxVisibleDots: 5,
                          activeDotColor: appColors.primary,
                          radius: AppSpacing.small,
                          dotHeight: AppSpacing.small,
                        ),
                      ),
                    ),
                  ],
                ),
              ) : FortressSupplicationsList(
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
