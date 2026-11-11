import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../states/fortress_supplications_state.dart';
import 'page_mode_supplications_page.dart';
import 'vertical_mode_supplications_page.dart';

class FortressSupplicationsPage extends StatelessWidget {
  const FortressSupplicationsPage({
    super.key,
    required this.chapterId,
  });

  final int chapterId;

  @override
  Widget build(BuildContext context) {
    final pageMode = context.select<FortressSupplicationState, bool>((s) => s.pageMode);
    return pageMode ? PageModeSupplicationsPage(chapterId: chapterId) : VerticalModeSupplicationsPage(chapterId: chapterId);
  }
}
