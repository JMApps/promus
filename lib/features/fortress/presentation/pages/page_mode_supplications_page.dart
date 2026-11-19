import 'package:material_ui/material_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../lists/fortress_horizontal_supplications_list.dart';
import '../widgets/fortress_chapter_header.dart';

/// Мольбы главы постранично. Только отображение: данные приходят
/// из FortressSupplicationsPage.
class PageModeSupplicationsPage extends StatefulWidget {
  const PageModeSupplicationsPage({
    super.key,
    required this.chapter,
    required this.supplications,
    required this.hasError,
    required this.onToggleMode,
  });

  final FortressChapterEntity? chapter;
  final List<FortressSupplicationEntity>? supplications;
  final bool hasError;
  final VoidCallback onToggleMode;

  @override
  State<PageModeSupplicationsPage> createState() => _PageModeSupplicationsPageState();
}

class _PageModeSupplicationsPageState extends State<PageModeSupplicationsPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final chapterModel = widget.chapter;
    final supplicationsList = widget.supplications;
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterModel?.chapterNumber ?? ''),
        actions: [
          IconButton.filledTonal(
            onPressed: widget.onToggleMode,
            icon: const Icon(Icons.swap_vertical_circle_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (chapterModel != null) FortressChapterHeader(chapterTitle: chapterModel.chapterTitle),
          if (supplicationsList != null) ...[
            Expanded(
              child: FortressHorizontalSupplicationsList(
                controller: _pageController,
                fortressChapterSupplications: supplicationsList,
              ),
            ),
            Padding(
              padding: AppPaddings.withoutTopMedium,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: supplicationsList.length,
                  effect: ScrollingDotsEffect(
                    maxVisibleDots: 5,
                    activeDotColor: appColors.primary,
                    dotHeight: AppSpacing.small,
                  ),
                ),
              ),
            ),
          ] else
            Expanded(
              child: Center(
                child: widget.hasError ? const Text(AppStrings.errorLoadData) : const CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
      ),
    );
  }
}