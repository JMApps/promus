import 'package:flutter/material.dart';

import '../../../../core/constants/font_families.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Текст аята с подсветкой найденных совпадений
class HighlightedAyahText extends StatelessWidget {
  const HighlightedAyahText({
    super.key,
    required this.text,
    required this.query,
    required this.isArabic,
  });

  final String text;
  final String query;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

    final style = isArabic ? TextStyle(
      fontSize: 21.0,
      fontFamily: isArabic ? FontFamilies.uthmanic : FontFamilies.notoNaskh,
      height: 2.5,
      letterSpacing: 0,
    ) : AppTextStyles.medium;

    final highlightStyle = style.copyWith(
      fontWeight: .bold,
      backgroundColor: appColors.primaryContainer,
    );

    return Text.rich(
      _buildHighlightedSpan(
        fullText: text,
        query: query,
        normalStyle: style,
        highlightStyle: highlightStyle,
        caseSensitive: isArabic,
      ),
      textDirection: isArabic ? .rtl : .ltr,
    );
  }

  TextSpan _buildHighlightedSpan({
    required String fullText,
    required String query,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
    required bool caseSensitive,
  }) {
    if (fullText.isEmpty || query.trim().isEmpty) {
      return TextSpan(text: fullText, style: normalStyle);
    }

    final source = caseSensitive ? fullText : fullText.toLowerCase();
    final target = caseSensitive ? query.trim() : query.toLowerCase().trim();

    final children = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = source.indexOf(target, start);

      if (index == -1) {
        if (start < fullText.length) {
          children.add(
            TextSpan(
              text: fullText.substring(start),
              style: normalStyle,
            ),
          );
        }
        break;
      }

      if (index > start) {
        children.add(
          TextSpan(
            text: fullText.substring(start, index),
            style: normalStyle,
          ),
        );
      }

      children.add(
        TextSpan(
          text: fullText.substring(index, index + target.length),
          style: highlightStyle,
        ),
      );

      start = index + target.length;
    }

    return TextSpan(children: children);
  }
}