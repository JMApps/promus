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
    _loadFootnote();
  }

  @override
  void didUpdateWidget(covariant FootnoteContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.footnoteId != widget.footnoteId) _loadFootnote();
  }

  void _loadFootnote() {
    final footnoteState = context.read<FortressFootnoteState>();
    final id = widget.footnoteId;

    if (footnoteState.cachedFootnoteById(id) != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      footnoteState.loadFootnoteById(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<FortressFootnoteState, (String?, bool, bool)>(
      selector: (_, state) => (
      state.cachedFootnoteById(widget.footnoteId)?.footnote,
      state.isLoading,
      state.error != null,
      ),
      builder: (context, data, _) {
        final (text, isLoading, hasError) = data;

        final html = switch ((text, isLoading, hasError)) {
          (final t?, _, _) => '[${widget.footnoteId}] – $t',
          (_, true, _) => null,
          (_, _, true) => AppStrings.errorLoad,
          _ => null,
        };

        return Container(
          padding: AppPaddings.withoutTopMedium,
          child: html == null ? (isLoading ? const Center(child: CircularProgressIndicator.adaptive()) : const SizedBox.shrink()) : Html(
            data: html,
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