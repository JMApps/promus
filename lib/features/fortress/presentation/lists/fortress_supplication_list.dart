import 'package:flutter/material.dart';

import '../../domain/entities/fortress_supplication_entity.dart';
import '../items/fortress_supplication_item.dart';

class FortressSupplicationList extends StatelessWidget {
  const FortressSupplicationList({
    super.key,
    required this.chapterSupplications,
  });

  final List<FortressSupplicationEntity> chapterSupplications;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: chapterSupplications.length,
      itemBuilder: (context, index) {
        final supplication = chapterSupplications[index];
        return FortressSupplicationItem(
          supplicationModel: supplication,
          supplicationsLength: chapterSupplications.length,
          index: index,
        );
      },
    );
  }
}
