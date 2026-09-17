import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/constants/font_families.dart';
import 'footnote_container.dart';

class MainHtmlWidget extends StatelessWidget {
  const MainHtmlWidget({
    super.key,
    required this.htmlContent,
    required this.textAlign,
  });

  final String htmlContent;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Html(
      data: htmlContent,
      style: {
        '#': Style(
          fontSize: FontSize(16.0),
          textAlign: textAlign,
        ),
        'a': Style(
          padding: HtmlPaddings.all(4),
          margin: .zero,
          color: appColors.primary,
          fontFamily: FontFamilies.notoNaskh,
          fontSize: FontSize(16.0),
        ),
      },
      onLinkTap: (String? footnoteId, _, _) {
        showModalBottomSheet(
          context: (context),
          useSafeArea: true,
          isScrollControlled: true,
          builder: (_) => FootnoteContainer(
            footnoteId: int.parse(footnoteId!),
          ),
        );
      },
    );
  }
}
