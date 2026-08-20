import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../main/states/page_number_state.dart';

class ToPageButton extends StatelessWidget {
  const ToPageButton({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return Container(
              margin: AppPaddings.topMedium,
              padding: AppPaddings.withoutTopMedium,
              child: Column(
                mainAxisSize: .min,
                children: [
                  Consumer<PageNumberState>(
                    builder: (context, pageNumberState, _) {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 1.75,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12,
                          ),
                        ),
                        child: Directionality(
                          textDirection: .rtl,
                          child: Slider(
                            showValueIndicator: .alwaysVisible,
                            value: pageNumberState.pageNumber.toDouble(),
                            label: '${pageNumberState.pageNumber}',
                            min: 1,
                            max: 604,
                            divisions: 604,
                            onChanged: (double value) {
                              pageNumberState.setPageNumber(value.round());
                            },
                            onChangeEnd: (double value) {
                              int pageNumber = value.round();
                              if (pageController.hasClients) {
                                pageController.jumpToPage(pageNumber - 1);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const Text(
                    'Перейти к странице',
                    style: AppTextStyles.medium,
                  ),
                  const SizedBox(height: AppSpacing.small),
                ],
              ),
            );
          },
        );
      },
      padding: .zero,
      tooltip: 'Перейти',
      color: appColors.secondary,
      icon: const Icon(Icons.auto_stories_outlined),
    );
  }
}
