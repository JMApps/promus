import 'package:flutter/material.dart';

import '../../domain/entities/fortress_chapter_entity.dart';

class FortressSupplicationsPage extends StatelessWidget {
  const FortressSupplicationsPage({
    super.key,
    required this.chapterModel,
  });

  final FortressChapterEntity chapterModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterModel.chapterNumber),
      ),
      body: Container(),
    );
  }
}
