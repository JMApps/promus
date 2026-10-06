import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../lists/fortress_supplication_list.dart';
import '../states/fortress_supplications_state.dart';
import '../widgets/main_html_widget.dart';

class FortressSupplicationsPage extends StatefulWidget {
  const FortressSupplicationsPage({
    super.key,
    required this.chapterModel,
  });

  final FortressChapterEntity chapterModel;

  @override
  State<FortressSupplicationsPage> createState() => _FortressSupplicationsPageState();
}

class _FortressSupplicationsPageState extends State<FortressSupplicationsPage> {
  @override
  void initState() {
    super.initState();
    final fortressSupplicationsState = context.read<FortressSupplicationState>();
    final chapterId = widget.chapterModel.chapterId;

    if (fortressSupplicationsState.cachedSupplicationsByChapter(chapterId) != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      fortressSupplicationsState.loadSupplicationsByChapter(chapterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final mqPadding = MediaQuery.of(context).padding;
    final chapterId = widget.chapterModel.chapterId;

    final isLoading = context.select<FortressSupplicationState, bool>((s) => s.isLoading);
    final error = context.select<FortressSupplicationState, Object?>((s) => s.error);
    final supplications = context.select<FortressSupplicationState, List<FortressSupplicationEntity>?>((s) => s.cachedSupplicationsByChapter(chapterId));

    return Scaffold(
      body: RawScrollbar(
        padding: .only(
          top: mqPadding.top + kToolbarHeight,
        ),
        thickness: 2.75,
        thumbColor: appColors.primary.withAlpha(125),
        radius: const .circular(AppSpacing.medium),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              title: Text(widget.chapterModel.chapterNumber),
            ),
            SliverToBoxAdapter(
              child: Card(
                margin: AppPaddings.topMediumSmallOther,
                color: appColors.inversePrimary,
                child: Padding(
                  padding: AppPaddings.small,
                  child: MainHtmlWidget(
                    htmlContent: widget.chapterModel.chapterTitle,
                    textAlign: .center,
                  ),
                ),
              ),
            ),
            if (supplications != null)
              FortressSupplicationList(chapterSupplications: supplications)
            else if (error != null && !isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(AppStrings.errorLoadData)),
              )
            else
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
          ],
        ),
      ),
    );
  }
}