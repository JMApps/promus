import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SearchErrorWidget extends StatelessWidget {
  const SearchErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: AppPaddings.medium,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: appColors.error,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              AppStrings.searchError(error.toString()),
              style: AppTextStyles.medium.copyWith(
                color: appColors.error,
              ),
              textAlign: .center,
              maxLines: 3,
              overflow: .ellipsis,
            ),
            const SizedBox(height: AppSpacing.large),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
