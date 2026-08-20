import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main/states/translate_mode_state.dart';

class TranslateModeButton extends StatelessWidget {
  const TranslateModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Consumer<TranslateModeState>(
      builder: (context, translationMode, _) {
        return IconButton(
          onPressed: () {
            translationMode.toggleTranslateMode();
          },
          padding: .zero,
          visualDensity: .compact,
          tooltip: translationMode.translateMode
              ? 'Страница мусхафа'
              : 'Страница смыслового перевода',
          color: appColors.secondary,
          icon: Icon(
            translationMode.translateMode
                ? Icons.menu_book_rounded
                : Icons.public_outlined,
          ),
        );
      },
    );
  }
}
