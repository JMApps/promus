import 'package:flutter/material.dart';

import '../../../../core/constants/font_families.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/text_matcher.dart';

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

    final style = isArabic
        ? const TextStyle(
      fontSize: 21.0,
      fontFamily: FontFamilies.uthmanic,
      height: 2.5,
      letterSpacing: 0,
    )
        : AppTextStyles.medium;

    final highlightStyle = style.copyWith(
      fontWeight: isArabic ? null : FontWeight.bold,
      backgroundColor: appColors.primaryContainer,
    );

    return Text.rich(
      _buildHighlightedSpan(
        fullText: text,
        normalStyle: style,
        highlightStyle: highlightStyle,
      ),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  TextSpan _buildHighlightedSpan({
    required String fullText,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
  }) {
    final ranges = TextMatcher.findRanges(
      text: fullText,
      query: query,
      isArabic: isArabic,
    );

    if (ranges.isEmpty) {
      return TextSpan(text: fullText, style: normalStyle);
    }

    final children = <TextSpan>[];
    var cursor = 0;

    for (final r in ranges) {
      if (r.start > cursor) {
        children.add(
          TextSpan(text: fullText.substring(cursor, r.start), style: normalStyle),
        );
      }
      children.add(
        TextSpan(text: fullText.substring(r.start, r.end), style: highlightStyle),
      );
      cursor = r.end;
    }

    if (cursor < fullText.length) {
      children.add(TextSpan(text: fullText.substring(cursor), style: normalStyle));
    }

    return TextSpan(children: children);
  }
}