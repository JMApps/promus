import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FortressSupplicationState>().loadSupplicationsByChapter(
        widget.chapterModel.chapterId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final mqPadding = MediaQuery.of(context).padding;
    final chapterId = widget.chapterModel.chapterId;

    final isLoading = context.select<FortressSupplicationState, bool>(
      (s) => s.isLoadingChapter(chapterId),
    );
    final error = context.select<FortressSupplicationState, Object?>(
      (s) => s.errorForChapter(chapterId),
    );
    final supplications = context.select<FortressSupplicationState, List<FortressSupplicationEntity>?>(
      (s) => s.supplicationsByChapter(chapterId),
    );

    return Scaffold(
      body: RawScrollbar(
        padding: EdgeInsets.only(
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
            if (isLoading && supplications == null)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else if (error != null && supplications == null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('$error')),
              )
            else
              FortressSupplicationList(
                chapterSupplications: supplications ?? const [],
              ),
          ],
        ),
      ),
    );
  }
}
