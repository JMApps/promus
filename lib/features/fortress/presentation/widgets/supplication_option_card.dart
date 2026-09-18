import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promus/features/fortress/presentation/states/fortress_footnote_state.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/fortress_supplication_entity.dart';

class SupplicationOptionCard extends StatelessWidget {
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
              final footnotes = await context.read<FortressFootnoteState>().loadFootnotesBySupplication(
                supplicationModel.supplicationId,
              );

              final buffer = StringBuffer();

              if (supplicationModel.arabicText != null) {
                buffer.writeln(supplicationModel.arabicText);
              }

              if (footnotes != null && footnotes.isNotEmpty) {
                if (buffer.isNotEmpty) buffer.writeln();
                for (final footnote in footnotes) {
                  buffer.writeln(footnote.footnote);
                }
              }

              final text = buffer.toString().trim();
              if (text.isEmpty) return;

              await Clipboard.setData(ClipboardData(text: text));

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Скопировано')),
                );
              }
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
                '$index/$supplicationsLength',
                style: AppTextStyles.small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
