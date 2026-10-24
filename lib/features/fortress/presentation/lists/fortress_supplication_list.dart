import 'package:flutter/material.dart';

import '../../domain/entities/fortress_supplication_entity.dart';
import '../items/fortress_supplication_item.dart';

class FortressSupplicationList extends StatelessWidget {
  const FortressSupplicationList({
    super.key,
    required this.fortressChapterSupplications,
  });

  final List<FortressSupplicationEntity> fortressChapterSupplications;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: fortressChapterSupplications.length,
      itemBuilder: (context, index) {
        final supplication = fortressChapterSupplications[index];
        return FortressSupplicationItem(
          supplicationModel: supplication,
          supplicationsLength: fortressChapterSupplications.length,
          index: index,
        );
      },
    );
  }
}
