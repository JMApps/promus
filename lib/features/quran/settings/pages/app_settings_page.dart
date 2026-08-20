import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_paddings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../states/display_settings_state.dart';
import '../states/locale_settings_state.dart';
import '../states/reading_settings_state.dart';
import '../widgets/ayah_text_size_slider.dart';
import '../widgets/default_settings_button.dart';
import '../widgets/setting_list_tile_item.dart';
import '../widgets/theme_color_picker.dart';
import '../widgets/theme_mode_drop_down.dart';
import '../widgets/translation_drop_down.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Настройки',
          style: AppTextStyles.medium,
        ),
        actions: const [
          DefaultSettingsButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const .only(
          bottom: kBottomNavigationBarHeight + AppSpacing.medium * 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
            Selector<ReadingSettingsState, bool>(
              selector: (_, state) => state.arabicNameSurah,
              builder: (context, value, _) {
                return SettingListTileItem(
                  value: value,
                  title: 'Название суры на арабском',
                  onChanged: (newValue) {
                    context.read<ReadingSettingsState>().arabicNameSurah =
                        newValue;
                  },
                );
              },
            ),
            Selector<ReadingSettingsState, bool>(
              selector: (_, state) => state.translationNameSurah,
              builder: (context, value, _) {
                return SettingListTileItem(
                  value: value,
                  title: 'Название суры на русском',
                  onChanged: (newValue) {
                    context.read<ReadingSettingsState>().translationNameSurah =
                        newValue;
                  },
                );
              },
            ),
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
            Selector<DisplaySettingsState, bool>(
              selector: (_, state) => state.displayAlwaysOn,
              builder: (context, value, _) {
                return SettingListTileItem(
                  value: value,
                  title: 'Дисплей всегда включён',
                  onChanged: (newValue) {
                    context.read<DisplaySettingsState>().setDisplayAlwaysOn(
                      newValue,
                    );
                  },
                );
              },
            ),
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
            Selector<DisplaySettingsState, int>(
              selector: (_, state) => state.appThemeModeIndex,
              builder: (context, value, _) {
                return ThemeModeDropDown(
                  value: value,
                  title: 'Тема приложения',
                  onChanged: (index) {
                    if (index == null) return;
                    context.read<DisplaySettingsState>().appThemeModeIndex =
                        index;
                  },
                );
              },
            ),
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
            Selector<DisplaySettingsState, Color>(
              selector: (_, state) => state.themeColor,
              builder: (context, color, _) {
                return ThemeColorPicker(
                  color: color,
                  onChanged: (newColor) {
                    if (newColor == null) return;
                    Navigator.pop(context);
                    context.read<DisplaySettingsState>().themeColor = newColor;
                  },
                );
              },
            ),
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
            Selector<LocaleSettingsState, int>(
              selector: (_, state) => state.translationNameIndex,
              builder: (context, selectedIndex, _) {
                return TranslationDropDown(
                  selectedIndex: selectedIndex,
                  onChanged: (index) {
                    context.read<LocaleSettingsState>().translationNameIndex =
                        index;
                  },
                );
              },
            ),
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
            Selector<ReadingSettingsState, bool>(
              selector: (_, state) => state.isArabicAyahShow,
              builder: (context, value, _) {
                return SettingListTileItem(
                  value: value,
                  title: 'Аят на арабском',
                  onChanged: (newValue) {
                    context.read<ReadingSettingsState>().isArabicAyahShow =
                        newValue;
                  },
                );
              },
            ),
            Selector<ReadingSettingsState, bool>(
              selector: (_, state) => state.isTranslationAyahShow,
              builder: (context, value, _) {
                return SettingListTileItem(
                  value: value,
                  title: 'Перевод аята',
                  onChanged: (newValue) {
                    context.read<ReadingSettingsState>().isTranslationAyahShow =
                        newValue;
                  },
                );
              },
            ),
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
            const Padding(
              padding: AppPaddings.medium,
              child: Text(
                'Размер текста аятов',
                style: AppTextStyles.medium,
              ),
            ),
            Selector<ReadingSettingsState, double>(
              selector: (_, state) => state.ayahArabicTextSize,
              builder: (context, size, _) {
                return AyahTextSizeSlider(
                  title: 'Арабский',
                  size: size,
                  onChanged: (value) {
                    context.read<ReadingSettingsState>().ayahArabicTextSize =
                        value;
                  },
                );
              },
            ),
            Selector<ReadingSettingsState, double>(
              selector: (_, state) => state.ayahTranslationTextSize,
              builder: (context, size, _) {
                return AyahTextSizeSlider(
                  title: 'Перевод',
                  size: size,
                  onChanged: (value) {
                    context
                            .read<ReadingSettingsState>()
                            .ayahTranslationTextSize =
                        value;
                  },
                );
              },
            ),
            const Divider(
              indent: AppSpacing.medium,
              endIndent: AppSpacing.medium,
            ),
          ],
        ),
      ),
    );
  }
}
