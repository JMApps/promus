import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../states/translate_mode_state.dart';

class TranslateModeButton extends StatelessWidget {
  const TranslateModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TranslateModeState, bool>(
      selector: (_, state) => state.translateMode,
      builder: (context, isTranslateMode, _) {
        return IconButton(
          isSelected: isTranslateMode,
          icon: const Icon(Icons.public_outlined),
          selectedIcon: const Icon(Icons.menu_book_rounded),
          padding: .zero,
          visualDensity: .compact,
          tooltip: isTranslateMode ? 'Страница мусхафа' : 'Страница смыслового перевода',
          onPressed: () {
            HapticFeedback.selectionClick();
            context.read<TranslateModeState>().toggleTranslateMode();
          },
        );
      },
    );
  }
}