import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_paddings.dart';
import '../../../settings/states/reading_settings_state.dart';

class BasmallahItem extends StatelessWidget {
  const BasmallahItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.bottomLarge,
      child: Text(
        'ﲚﲛﲞﲤ',
        textDirection: .ltr,
        style: TextStyle(
          fontSize: context.read<ReadingSettingsState>().ayahArabicTextSize,
          fontFamily: 'QCF_BSML',
          height: 1,
        ),
        textAlign: .center,
      ),
    );
  }
}
