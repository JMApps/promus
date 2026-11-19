import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../lists/fortress_supplications_list.dart';
import '../widgets/fortress_chapter_header.dart';

/// Мольбы главы одним списком. Только отображение: данные приходят
/// из FortressSupplicationsPage.
class VerticalModeSupplicationsPage extends StatelessWidget {
  const VerticalModeSupplicationsPage({
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
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.paddingOf(context).top;
    final chapterModel = chapter;
    final supplicationsList = supplications;
    return Scaffold(
      body: RawScrollbar(
        padding: .only(top: topPadding + kToolbarHeight),
        thickness: 2.75,
        thumbColor: appColors.primary.withAlpha(125),
        radius: const .circular(AppSpacing.medium),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              title: Text(chapterModel?.chapterNumber ?? ''),
              actions: [
                IconButton.filledTonal(
                  onPressed: onToggleMode,
                  icon: const Icon(Icons.swap_horizontal_circle_rounded),
                ),
              ],
            ),
            if (chapterModel != null)
              SliverToBoxAdapter(
                child: FortressChapterHeader(chapterTitle: chapterModel.chapterTitle),
              ),
            if (supplicationsList != null)
              FortressSupplicationsList(
                fortressChapterSupplications: supplicationsList,
              )
            else
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: hasError ? const Text(AppStrings.errorLoadData) : const CircularProgressIndicator.adaptive(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}