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
import '../states/fortress_chapters_state.dart';
import '../states/fortress_supplications_state.dart';
import '../widgets/main_html_widget.dart';

class PageModeSupplicationsPage extends StatefulWidget {
  const PageModeSupplicationsPage({
    super.key,
    required this.chapterId,
  });

  final int chapterId;

  @override
  State<PageModeSupplicationsPage> createState() =>
      _PageModeSupplicationsPageState();
}

class _PageModeSupplicationsPageState extends State<PageModeSupplicationsPage> {
  late final FortressSupplicationState _fortressSupplicationsState;
  late final PageController _supplicationPageController;

  @override
  void initState() {
    super.initState();
    _fortressSupplicationsState = context.read<FortressSupplicationState>();
    _supplicationPageController = PageController();

    if (_fortressSupplicationsState.cachedSupplicationsByChapter(widget.chapterId) != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _fortressSupplicationsState.loadSupplicationsByChapter(
        widget.chapterId,
      );
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
    final isLoading = context.select<FortressSupplicationState, bool>(
      (s) => s.isLoading,
    );
    final error = context.select<FortressSupplicationState, Object?>(
      (s) => s.error,
    );
    final chapter = context
        .select<FortressChapterState, FortressChapterEntity?>(
          (s) => s.chapterById(widget.chapterId),
        );
    final supplications = context
        .select<FortressSupplicationState, List<FortressSupplicationEntity>?>(
          (s) => s.cachedSupplicationsByChapter(widget.chapterId),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter!.chapterNumber),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              _fortressSupplicationsState.changePageMode();
            },
            icon: const Icon(Icons.swap_vertical_circle_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
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
          if (supplications != null)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: FortressHorizontalSupplicationsList(
                      controller: _supplicationPageController,
                      fortressChapterSupplications: supplications,
                    ),
                  ),
                  Padding(
                    padding: AppPaddings.withoutTopMedium,
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
            )
          else if (error != null && !isLoading)
            const Center(
              child: Text(AppStrings.errorLoadData),
            )
          else
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        ],
      ),
    );
  }
}
