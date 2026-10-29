import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../state/selection_cities_state.dart';

class SearchCityTextField extends StatelessWidget {
  const SearchCityTextField({
    super.key,
    required this.editingController,
  });

  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    final allCitiesState = context.read<AllCitiesState>();
    final appColors = Theme.of(context).colorScheme;
    return Padding(
      padding: AppPaddings.small,
      child: CupertinoTextField(
        controller: editingController,
        autocorrect: false,
        autofocus: true,
        placeholder: AppStrings.enterQuery,
        onChanged: (query) => allCitiesState.onEndSearchQuery(
          query.toLowerCase().trim(),
        ),
        textAlign: .center,
        clearButtonMode: .editing,
        padding: AppPaddings.hrMediumVrSmall,
        decoration: BoxDecoration(
          borderRadius: AppRadius.medium,
          color: appColors.surfaceContainerHigh,
        ),
      ),
    );
  }
}
