import 'package:flutter/material.dart';

import '../../../../../core/theme/app_paddings.dart';

class BasmallahItem extends StatelessWidget {
  const BasmallahItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppPaddings.bottomLarge,
      child: Text(
        'ﲚﲛﲞﲤ',
        textDirection: .ltr,
        style: TextStyle(
          fontSize: 25.0,
          fontFamily: 'QCF_BSML',
          height: 1,
        ),
        textAlign: .center,
      ),
    );
  }
}
