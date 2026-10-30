import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_paddings.dart';

class ErrorLoadDataWidget extends StatelessWidget {
  const ErrorLoadDataWidget({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppPaddings.medium,
        child: Text(
          '${AppStrings.errorLoadData}\n$errorMessage',
          textAlign: .center,
        ),
      ),
    );
  }
}
