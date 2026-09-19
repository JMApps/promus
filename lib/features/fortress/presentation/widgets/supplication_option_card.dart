import 'package:flutter/material.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/fortress_supplication_entity.dart';

class SupplicationOptionCard extends StatefulWidget {
  const SupplicationOptionCard({
    super.key,
    required this.supplicationModel,
    required this.supplicationsLength,
    required this.index,
  });

  final FortressSupplicationEntity supplicationModel;
  final int supplicationsLength;
  final int index;

  @override
  State<SupplicationOptionCard> createState() => _SupplicationOptionCardState();
}

class _SupplicationOptionCardState extends State<SupplicationOptionCard> {
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Card(
      margin: AppPaddings.verticalSmall,
      color: appColors.surface,
      child: Row(
        mainAxisAlignment: .spaceAround,
        children: [
          IconButton(
            onPressed: () async {
            },
            iconSize: 18.0,
            visualDensity: .compact,
            padding: .zero,
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: () {},
            iconSize: 18.0,
            visualDensity: .compact,
            padding: .zero,
            icon: const Icon(Icons.ios_share),
          ),
          Card(
            color: appColors.secondaryContainer,
            shape: AppShapes.small,
            child: Padding(
              padding: AppPaddings.hrMediumVrXSmall,
              child: Text(
                '${widget.index}/${widget.supplicationsLength}',
                style: AppTextStyles.small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
