import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/routes/names_router.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../main/states/page_number_state.dart';
import '../../../reader/data/args/reader_args.dart';
import '../../../surah/presentation/states/surah_name_state.dart';
import '../../domain/entities/juz_entity.dart';

class JuzItem extends StatelessWidget {
  const JuzItem({
    super.key,
    required this.juz,
    required this.index,
  });

  final JuzEntity juz;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);
    final surahFirstVerseKey = context.select<SurahNameState, String?>((s) => s.surahByVerseKey('Сура', juz.firstVerseKey, 'Аят'.toLowerCase()));
    return InkWell(
      onTap: () async {
        context.read<PageNumberState>().setPageNumber(juz.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageReader,
          arguments: ReaderArgs(pageNumber: juz.startPageNumber),
        );
      },
      child: Container(
        padding: AppPaddings.hrSmallVrLarge,
        decoration: BoxDecoration(
          color: index.isOdd ? itemEvenColor : itemOddColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Text(
                juz.juzNumber.toString(),
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    surahFirstVerseKey ?? '...',
                    style: AppTextStyles.medium,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    AppStrings.ayahsCount(juz.versesCount).toString(),
                    style: AppTextStyles.small,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Text(
              'Стр.\n${juz.startPageNumber}',
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
