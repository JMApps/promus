import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../states/bookmarks_state.dart';

class CleanFavoritesButton extends StatelessWidget {
  const CleanFavoritesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Padding(
              padding: AppPaddings.withoutTopMedium,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .stretch,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context
                                      .read<BookmarksState>()
                                      .clearAllFavorites();
                                },
                                child: Text(
                                  'Удалить',
                                  style: AppTextStyles.medium.copyWith(
                                    color: appColors.error,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Отменить',
                                  style: AppTextStyles.medium,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Удалить всё избранное',
                      style: AppTextStyles.medium.copyWith(
                        color: appColors.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Отмена', style: AppTextStyles.medium),
                  ),
                ],
              ),
            );
          },
        );
      },
      tooltip: 'Удалить всё избранное',
      color: appColors.secondary,
      icon: const Icon(Icons.delete_rounded),
    );
  }
}
