import 'package:flutter/material.dart';

import '../../domain/entities/surah_name_entity.dart';
import '../items/favorite_name_item.dart';

class FavoriteSurahList extends StatelessWidget {
  const FavoriteSurahList({
    super.key,
    required this.favoriteSurahs,
  });

  final List<SurahNameEntity> favoriteSurahs;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: favoriteSurahs.length,
      itemBuilder: (context, index) {
        final surah = favoriteSurahs[index];
        return FavoriteSurahNameItem(
          surah: surah,
          index: index,
        );
      },
    );
  }
}
