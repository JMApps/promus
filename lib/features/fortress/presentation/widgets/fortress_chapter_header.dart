import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_shapes.dart';
import 'main_html_widget.dart';

/// Плашка с названием главы — общая для обоих режимов показа.
class FortressChapterHeader extends StatelessWidget {
  const FortressChapterHeader({
    super.key,
    required this.chapterTitle,
  });

  final String chapterTitle;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Padding(
      padding: AppPaddings.topMediumSmallOther,
      child: Ink(
        decoration: ShapeDecoration(
          shape: AppShapes.medium,
          gradient: LinearGradient(
            begin: .centerLeft,
            colors: [
              appColors.inversePrimary,
              appColors.tertiaryContainer,
              appColors.secondaryContainer,
            ],
          ),
        ),
        child: Padding(
          padding: AppPaddings.small,
          child: MainHtmlWidget(
            htmlContent: chapterTitle,
            textAlign: .center,
          ),
        ),
      ),
    );
  }
}