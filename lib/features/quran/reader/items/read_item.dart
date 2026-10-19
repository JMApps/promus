import 'package:flutter/material.dart';

import '../../ayahs/lists/ayah_by_ayah_list.dart';
import '../../domain/entities/mushaf_page_entity.dart';

class ReadItem extends StatelessWidget {
  const ReadItem({
    super.key,
    required this.rows,
  });

  final List<MushafPageEntity> rows;

  @override
  Widget build(BuildContext context) {
    return AyahByAyahList(
      rows: rows,
    );
  }
}
