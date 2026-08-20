import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: appColors.secondary,
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            message ?? 'Ничего не найдено',
            style: AppTextStyles.medium,
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
