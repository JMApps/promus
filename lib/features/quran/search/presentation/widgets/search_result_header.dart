import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_paddings.dart';
import '../../../../../core/theme/app_text_styles.dart';

class SearchResultsHeader extends StatelessWidget {
  const SearchResultsHeader({
    super.key,
    required this.query,
    required this.matchCount,
    required this.resultCount,
  });

  final String query;
  final int matchCount;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

    final matchesText = AppStrings.searchResults(matchCount);

    return Container(
      padding: AppPaddings.small,
      color: appColors.tertiaryContainer,
      child: Text(
        AppStrings.searchByQuery(query, matchesText),
        style: AppTextStyles.medium,
        textAlign: .center,
        overflow: .ellipsis,
      ),
    );
  }
}
