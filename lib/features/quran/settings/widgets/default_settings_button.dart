import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../states/settings_reset_coordinator.dart';

class DefaultSettingsButton extends StatelessWidget {
  const DefaultSettingsButton({super.key});

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
                                      .read<SettingsResetCoordinator>()
                                      .resetAll();
                                },
                                child: Text(
                                  'Сброс',
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
                                  'Отмена',
                                  style: AppTextStyles.medium,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'По умолчанию',
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
                      'Отмена',
                      style: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      tooltip: 'По умолчанию',
      color: appColors.secondary,
      icon: const Icon(Icons.restore),
    );
  }
}
