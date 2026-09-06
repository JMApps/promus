import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../states/fortress_footnote_state.dart';

class FootnoteContainer extends StatefulWidget {
  const FootnoteContainer({
    super.key,
    required this.footnoteId,
  });

  final int footnoteId;

  @override
  State<FootnoteContainer> createState() => _FootnoteContainerState();
}

class _FootnoteContainerState extends State<FootnoteContainer> {
  @override
  void initState() {
    super.initState();
    context.read<FortressFootnoteState>().loadFootnote(widget.footnoteId);
  }

  @override
  void didUpdateWidget(covariant FootnoteContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.footnoteId != widget.footnoteId) {
      context.read<FortressFootnoteState>().loadFootnote(widget.footnoteId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<FortressFootnoteState, (String?, bool, bool)>(
      selector: (_, state) => (
        state.footnoteById(widget.footnoteId)?.footnote,
        state.isLoading(widget.footnoteId),
        state.hasError(widget.footnoteId),
      ),
      builder: (context, data, _) {
        final (text, isLoading, hasError) = data;
        return Container(
          padding: AppPaddings.withoutTopMedium,
          child: Html(
            data: hasError ? AppStrings.errorLoad : '[${widget.footnoteId}] – $text',
            style: {
              '#': Style(
                padding: HtmlPaddings.only(left: 4, right: 4, bottom: 4),
                margin: .zero,
                fontSize: FontSize(16.0),
              ),
            },
          ),
        );
      },
    );
  }
}
