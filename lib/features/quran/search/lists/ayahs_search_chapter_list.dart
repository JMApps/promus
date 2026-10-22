import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../items/search_ayah_by_ayah_item.dart';

class AyahsSearchList extends StatelessWidget {
  const AyahsSearchList({super.key, required this.future});

  final Future<List<AyahByAyahEntity>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AyahByAyahEntity>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final ayahs = snapshot.data ?? const [];
        if (ayahs.isEmpty) {
          return Center(
            child: Text(AppStrings.searchResults(snapshot.data!.length)),
          );
        }
        return Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: ayahs.length,
            itemBuilder: (context, index) => SearchAyahByAyahItem(
              ayah: ayahs[index],
              index: index,
            ),
          ),
        );
      },
    );
  }
}
