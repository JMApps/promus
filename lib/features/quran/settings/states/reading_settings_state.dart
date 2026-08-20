import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/constants/app_constants.dart';

class ReadingSettingsState extends ChangeNotifier {
  final Box<dynamic> _appSettingsBox = Hive.box(
    AppConstants.mainAppSettingsBox,
  );

  ReadingSettingsState() {
    _loadSettings();
  }

  late bool _arabicNameSurah;
  late bool _translationNameSurah;
  late bool _isArabicAyahShow;
  late bool _isTranslationAyahShow;
  late double _ayahArabicTextSize;
  late double _ayahTranslationTextSize;

  bool get arabicNameSurah => _arabicNameSurah;

  set arabicNameSurah(bool value) {
    if (_arabicNameSurah == value) return;
    _arabicNameSurah = value;
    _appSettingsBox.put(AppConstants.keySurahArabicName, value);
    notifyListeners();
  }

  bool get translationNameSurah => _translationNameSurah;

  set translationNameSurah(bool value) {
    if (_translationNameSurah == value) return;
    _translationNameSurah = value;
    _appSettingsBox.put(AppConstants.keyTranslationNameSurah, value);
    notifyListeners();
  }

  double get ayahArabicTextSize => _ayahArabicTextSize;

  set ayahArabicTextSize(double size) {
    if (_ayahArabicTextSize == size) return;
    _ayahArabicTextSize = size;
    _appSettingsBox.put(AppConstants.keyAyahArabicTextSize, size);
    notifyListeners();
  }

  double get ayahTranslationTextSize => _ayahTranslationTextSize;

  set ayahTranslationTextSize(double size) {
    if (_ayahTranslationTextSize == size) return;
    _ayahTranslationTextSize = size;
    _appSettingsBox.put(AppConstants.keyAyahTranslationTextSize, size);
    notifyListeners();
  }

  bool get isArabicAyahShow => _isArabicAyahShow;

  set isArabicAyahShow(bool state) {
    if (_isArabicAyahShow == state) return;

    if (!state && !_isTranslationAyahShow) {
      _isTranslationAyahShow = true;
      _appSettingsBox.put(AppConstants.keyShowTranslationAyah, true);
    }

    _isArabicAyahShow = state;
    _appSettingsBox.put(AppConstants.keyShowArabicAyah, state);
    notifyListeners();
  }

  bool get isTranslationAyahShow => _isTranslationAyahShow;

  set isTranslationAyahShow(bool state) {
    if (_isTranslationAyahShow == state) return;

    if (!state && !_isArabicAyahShow) {
      _isArabicAyahShow = true;
      _appSettingsBox.put(AppConstants.keyShowArabicAyah, true);
    }

    _isTranslationAyahShow = state;
    _appSettingsBox.put(AppConstants.keyShowTranslationAyah, state);
    notifyListeners();
  }

  void _loadSettings() {
    _arabicNameSurah = _appSettingsBox.get(
      AppConstants.keySurahArabicName,
      defaultValue: true,
    );
    _translationNameSurah = _appSettingsBox.get(
      AppConstants.keyTranslationNameSurah,
      defaultValue: true,
    );
    _isArabicAyahShow = _appSettingsBox.get(
      AppConstants.keyShowArabicAyah,
      defaultValue: true,
    );
    _isTranslationAyahShow = _appSettingsBox.get(
      AppConstants.keyShowTranslationAyah,
      defaultValue: true,
    );
    _ayahArabicTextSize = _appSettingsBox.get(
      AppConstants.keyAyahArabicTextSize,
      defaultValue: 19.0,
    );
    _ayahTranslationTextSize = _appSettingsBox.get(
      AppConstants.keyAyahTranslationTextSize,
      defaultValue: 17.0,
    );
  }

  void reload() {
    _loadSettings();
    notifyListeners();
  }
}
