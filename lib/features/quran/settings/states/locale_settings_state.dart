import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_device_locales.dart';

class LocaleSettingsState extends ChangeNotifier {
  LocaleSettingsState() {
    _loadSettings();
  }

  final Box<dynamic> _appSettingsBox = Hive.box(
    AppConstants.mainAppSettingsBox,
  );

  late int _appLocaleIndex;
  late int _translationNameIndex;

  int get appLocaleIndex => _appLocaleIndex;

  Locale get appLocale => AppDeviceLocales.appLocales[_appLocaleIndex];

  set appLocaleIndex(int index) {
    if (index < 0 || index >= AppDeviceLocales.appLocales.length) return;
    if (_appLocaleIndex == index) return;
    _appLocaleIndex = index;
    _appSettingsBox.put(AppConstants.keyAppLocaleIndex, index);
    notifyListeners();
  }

  int get translationNameIndex => _translationNameIndex;

  set translationNameIndex(int index) {
    if (index < 0 || index >= AppDeviceLocales.ayahTranslations.length) return;
    if (_translationNameIndex == index) return;
    _translationNameIndex = index;
    _appSettingsBox.put(AppConstants.keyTranslationNameIndex, index);
    notifyListeners();
  }

  void _loadSettings() {
    _appLocaleIndex = _appSettingsBox.get(
      AppConstants.keyAppLocaleIndex,
      defaultValue: _defaultLocaleIndex(),
    );

    final languageCode =
        AppDeviceLocales.appLocales[_appLocaleIndex].languageCode;
    final defaultIndex =
        AppDeviceLocales.defaultTranslationIndex[languageCode] ?? 0;

    _translationNameIndex = _appSettingsBox.get(
      AppConstants.keyTranslationNameIndex,
      defaultValue: defaultIndex,
    );
  }

  int _defaultLocaleIndex() {
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    for (var i = 0; i < AppDeviceLocales.appLocales.length; i++) {
      if (AppDeviceLocales.appLocales[i].languageCode == deviceCode) return i;
    }
    return 0;
  }

  void reload() {
    _loadSettings();
    notifyListeners();
  }
}
