import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../items/fortress_chapter_item.dart';

class FortressSearchChapterList extends StatelessWidget {
  const FortressSearchChapterList({
    super.key,
    required this.chapters,
    required this.query,
  });

  final List<FortressChapterEntity> chapters;
  final String query;

  @override
  Widget build(BuildContext context) {
    final filtered = query.isEmpty ? chapters : chapters.where((c) {
      final lowerQuery = query.toLowerCase();
      return c.chapterTitle.toLowerCase().contains(lowerQuery) ||
          c.chapterId.toString().contains(lowerQuery);
    }).toList();

    if (filtered.isEmpty) {
      return const Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 150,
          ),
          Text(
            AppStrings.searchIsEmpty,
            style: AppTextStyles.medium,
            textAlign: .center,
          ),
        ],
      );
    }

    return Scrollbar(
      child: ListView.builder(
        padding: .zero,
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final chapter = filtered[index];
          return FortressChapterItem(
            chapterModel: chapter,
            index: index,
          );
        },
      ),
    );
  }
}
