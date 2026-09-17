import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../widgets/main_html_widget.dart';

class FortressSupplicationsPage extends StatelessWidget {
  const FortressSupplicationsPage({
    super.key,
    required this.chapterModel,
  });

  final FortressChapterEntity chapterModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            title: Text(chapterModel.chapterNumber),
          ),
          SliverToBoxAdapter(
            child: Card(
              margin: AppPaddings.small,
              child: Padding(
                padding: AppPaddings.small,
                child: MainHtmlWidget(
                  htmlContent: chapterModel.chapterTitle,
                  textAlign: .center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
