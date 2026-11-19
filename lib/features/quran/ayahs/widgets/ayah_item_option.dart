import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../surah/states/surah_name_state.dart';

class AyahItemOption extends StatelessWidget {
  const AyahItemOption({
    super.key,
    required this.ayahId,
    required this.wholeAyah,
    required this.verseKey,
    required this.ayahIndex,
  });

  final int ayahId;
  final String wholeAyah;
  final String verseKey;
  final int ayahIndex;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final source = context.select<SurahNameState, String?>(
          (s) => s.surahByVerseKey(AppStrings.surah, verseKey, AppStrings.ayah.toLowerCase()),
    );
    // Если список сур ещё не загружен, подпись — просто ключ аята, а не «null».
    final text = '$wholeAyah\n\n${source ?? verseKey}';
    return Padding(
      padding: AppPaddings.withoutTopMedium,
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Container(
            height: 50,
            padding: AppPaddings.small,
            alignment: .center,
            decoration: BoxDecoration(
              color: appColors.secondaryContainer.withAlpha(155),
              borderRadius: AppRadius.small,
            ),
            child: Text(verseKey),
          ),
          IconButton(
            tooltip: AppStrings.copy,
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await Clipboard.setData(ClipboardData(text: text));
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: appColors.inversePrimary,
                    content: Text(
                      AppStrings.copied,
                      style: AppTextStyles.medium.copyWith(color: appColors.primary),
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
            },
            icon: const Icon(Icons.copy_rounded),
          ),
          IconButton(
            tooltip: AppStrings.share,
            onPressed: () {
              final box = context.findRenderObject() as RenderBox?;
              final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
              Navigator.pop(context);
              unawaited(
                SharePlus.instance.share(
                  ShareParams(text: text, sharePositionOrigin: origin),
                ),
              );
            },
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
    );
  }
}