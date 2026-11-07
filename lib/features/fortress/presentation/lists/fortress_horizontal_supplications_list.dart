import 'package:flutter/material.dart';

import '../../domain/entities/fortress_supplication_entity.dart';
import '../items/fortress_supplication_item.dart';

class FortressHorizontalSupplicationsList extends StatelessWidget {
  const FortressHorizontalSupplicationsList({
    super.key,
    required this.controller,
    required this.fortressChapterSupplications,
  });

  final PageController controller;
  final List<FortressSupplicationEntity> fortressChapterSupplications;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: fortressChapterSupplications.length,
      itemBuilder: (context, index) {
        final supplication = fortressChapterSupplications[index];
        return SingleChildScrollView(
          child: FortressSupplicationItem(
            supplicationModel: supplication,
            supplicationsLength: fortressChapterSupplications.length,
            index: index,
          ),
        );
      },
    );
  }
}
