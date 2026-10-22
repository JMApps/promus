import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/mushaf_page_meta_state.dart';
import '../items/favorite_name_item.dart';
import '../states/surah_bookmark_state.dart';
import '../states/surah_name_state.dart';

class LastOpenedSurahList extends StatelessWidget {
  const LastOpenedSurahList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SurahBookmarkState, MushafPageMetaState, SurahNameState>(
      builder: (context, bookmarks, meta, surahs, _) {
        final items = bookmarks.resolveLastOpenedSurahs(
          meta: meta,
          surahs: surahs,
        );

        if (items.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverList.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return FavoriteSurahNameItem(
              surah: item.surah,
              pageNumber: item.pageNumber,
            );
          },
        );
      },
    );
  }
}