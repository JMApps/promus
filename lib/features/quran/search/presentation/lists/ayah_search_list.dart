import 'package:flutter/material.dart';

import '../../../ayahs/domain/entities/ayah_by_ayah_entity.dart';
import '../items/search_ayah_item.dart';

class AyahSearchList extends StatelessWidget {
  const AyahSearchList({
    super.key,
    required this.searchResultList,
    required this.query,
  });

  final List<AyahByAyahEntity> searchResultList;
  final String query;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: .zero,
      itemCount: searchResultList.length,
      itemBuilder: (context, index) {
        final ayah = searchResultList[index];
        return SearchAyahItem(
          ayah: ayah,
          index: index,
          query: query,
          key: ValueKey(ayah.ayahId),
        );
      },
    );
  }
}
