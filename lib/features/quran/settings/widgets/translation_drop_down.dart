import 'package:flutter/material.dart';

import '../../../../core/constants/app_device_locales.dart';
import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_radius.dart';

class TranslationDropDown extends StatelessWidget {
  const TranslationDropDown({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Смысловой перевод'),
      trailing: DropdownButton<int>(
        borderRadius: AppRadius.medium,
        elevation: 1,
        padding: AppPaddings.withoutRightSmall,
        alignment: Alignment.center,
        value: selectedIndex,
        items: List.generate(
          AppDeviceLocales.ayahTranslations.length,
          (index) => DropdownMenuItem<int>(
            value: index,
            child: Text(
              AppDeviceLocales.ayahTranslations[index].name,
              style: TextStyle(
                fontWeight: selectedIndex == index
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              textAlign: .center,
            ),
          ),
        ),
        underline: const SizedBox(),
        onChanged: (int? newIndex) {
          if (newIndex != null) onChanged(newIndex);
        },
      ),
    );
  }
}
