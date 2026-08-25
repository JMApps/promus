import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/routes/names_router.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../main/domain/entities/page_meta_entity.dart';
import '../../../main/states/page_number_state.dart';
import '../../../reader/data/args/reader_args.dart';
import '../../../surah/presentation/states/surah_name_state.dart';
import '../states/bookmarks_state.dart';

class FavoritePageItem extends StatelessWidget {
  const FavoritePageItem({
    super.key,
    required this.pageMetaModel,
    required this.index,
  });

  final PageMetaEntity pageMetaModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);
    final surahNameTranscription = context.select<SurahNameState, String>(
      (s) => s.surahByNumber(surahNumber: pageMetaModel.surahNumber)!.nameTranscription,
    );
    return InkWell(
      onTap: () {
        context.read<PageNumberState>().setPageNumber(pageMetaModel.pageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageReader,
          arguments: ReaderArgs(pageNumber: pageMetaModel.pageNumber),
        );
      },
      child: Container(
        padding: AppPaddings.hrSmallVrLarge,
        decoration: BoxDecoration(
          color: index.isOdd ? itemEvenColor : itemOddColor,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<BookmarksState>().toggleFavoritePage(pageNumber: pageMetaModel.pageNumber);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: appColors.inversePrimary,
                    content: Text(
                      'Удалить из избранного',
                      style: AppTextStyles.medium.copyWith(color: appColors.onSurface),
                    ),
                  ),
                );
              },
              padding: .zero,
              visualDensity: .compact,
              color: appColors.secondary,
              icon: Icon(
                Icons.bookmark_rounded,
                color: appColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    'Сура $surahNameTranscription',
                    textAlign: .start,
                  ),
                  Text(
                    'Стр. ${pageMetaModel.pageNumber}, джуз ${pageMetaModel.juzNumber}',
                    textAlign: .start,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Text(
              'Стр.\n${pageMetaModel.pageNumber}',
              style: AppTextStyles.small.copyWith(
                color: appColors.secondary,
              ),
              textAlign: .center,
            ),
            const SizedBox(width: AppSpacing.small),
          ],
        ),
      ),
    );
  }
}
