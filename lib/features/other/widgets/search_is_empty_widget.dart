import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchIsEmptyWidget extends StatelessWidget {
  const SearchIsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .stretch,
      mainAxisAlignment: .center,
      children: [
        Icon(
          Icons.search_off_rounded,
          size: 100,
        ),
        Text(
          AppStrings.searchIsEmpty,
          style: AppTextStyles.medium,
          textAlign: .center,
        ),
      ],
    );
  }
}
