import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

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
          spacing: AppSpacing.medium,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: appColors.error,
            ),
            Text(
              AppStrings.searchError(error.toString()),
              style: AppTextStyles.medium.copyWith(
                color: appColors.error,
              ),
              textAlign: .center,
              maxLines: 3,
              overflow: .ellipsis,
            ),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}