import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/juz_entity.dart';
import '../items/juz_item.dart';
class JuzList extends StatelessWidget {
  const JuzList({
    super.key,
    required this.scrollController,
    required this.juzs,
  });

  final ScrollController scrollController;
  final List<JuzEntity> juzs;
  @override
  Widget build(BuildContext context) {
    final double bottomHeight = kBottomNavigationBarHeight + AppSpacing.medium;
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        primary: false,
        padding: .only(bottom: bottomHeight),
        itemCount: juzs.length,
        itemBuilder: (context, index) {
          final juz = juzs[index];
          return JuzItem(
            juz: juz,
            index: index,
          );
        },
      ),
    );
  }
}
