import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../states/fortress_footnote_state.dart';

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
      elevation: 0,
      color: appColors.primaryContainer.withAlpha(175),
      child: Row(
        mainAxisAlignment: .spaceAround,
        children: [
          IconButton(
            onPressed: () async {
              final content = await _fullContent(context);
              await Clipboard.setData(ClipboardData(text: content));

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: appColors.inversePrimary,
                  content: Text(
                    AppStrings.copied,
                    style: AppTextStyles.medium.copyWith(
                      color: appColors.primary,
                    ),
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            iconSize: 18.0,
            visualDensity: .compact,
            padding: .zero,
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: () async {
              final box = context.findRenderObject() as RenderBox?;
              final content = await _fullContent(context);

              await SharePlus.instance.share(
                ShareParams(
                  text: content,
                  sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
                ),
              );
            },
            iconSize: 18.0,
            visualDensity: .compact,
            padding: .zero,
            icon: const Icon(Icons.ios_share),
          ),
          Card(
            color: appColors.inversePrimary,
            shape: AppShapes.small,
            elevation: 0,
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

  Future<String> _fullContent(BuildContext context) async {
    final footnoteContent = await _footnoteContent(context, supplicationModel.supplicationId);
    return [
      _supplicationContent(supplicationModel),
      footnoteContent,
    ].where((s) => s.trim().isNotEmpty).join('\n\n');
  }

  String _supplicationContent(FortressSupplicationEntity model) {
    final parts = [
      model.arabicText,
      model.transcriptionText,
      _stripHtml(model.translationHtml),
    ].whereType<String>().where((s) => s.trim().isNotEmpty);

    return parts.join('\n\n');
  }

  Future<String> _footnoteContent(BuildContext context, int supplicationId) async {
    final footnoteState = context.read<FortressFootnoteState>();
    await footnoteState.loadFootnotesBySupplication(supplicationId);
    return _stripHtml(footnoteState.formattedFootnotesText(supplicationId) ?? '');
  }

  String _stripHtml(String htmlString) => html_parser.parse(htmlString).body?.text ?? '';
}
