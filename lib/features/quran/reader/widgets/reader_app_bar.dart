import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../states/mushaf_page_meta_state.dart';
import '../../states/mushaf_page_number_state.dart';
import '../../surah/states/surah_name_state.dart';
import '../states/reader_app_bar_state.dart';
import 'to_page_button.dart';

class ReaderAppBar extends StatelessWidget {
  const ReaderAppBar({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final showAppBar = context.select<ReaderAppBarState, bool>((s) => s.showAppBar);
    final page = context.select<MushafPageNumberState, int>((s) => s.pageNumber);
    final pageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>((s) => s.metaByPageNumber(page));
    final surahName = context.select<SurahNameState, SurahNameEntity?>((s) => pageMeta == null ? null : s.surahByNumber(surahNumber: pageMeta.surahNumber - 1));
    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      offset: showAppBar ? .zero : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showAppBar ? 1 : 0,
        child: IgnorePointer(
          ignoring: !showAppBar,
          child: AppBar(
            elevation: 3.5,
            titleSpacing: 0,
            title: pageMeta == null ? Text('$page') : Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  '${AppStrings.surah} ${surahName?.nameTranscription ?? ''}',
                  style: AppTextStyles.medium,
                ),
                Text(
                  '${AppStrings.page} $page, ${AppStrings.juz.toLowerCase()} ${pageMeta.juzNumber}',
                  style: AppTextStyles.small,
                ),
              ],
            ),
            actions: [
              ToPageButton(pageController: pageController),
            ],
          ),
        ),
      ),
    );
  }
}
