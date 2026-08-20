import 'package:hive_ce/hive.dart';

import '../../../../core/constants/app_constants.dart';
import 'display_settings_state.dart';
import 'locale_settings_state.dart';
import 'reading_settings_state.dart';

class SettingsResetCoordinator {
  final LocaleSettingsState _locale;
  final DisplaySettingsState _display;
  final ReadingSettingsState _reading;

  SettingsResetCoordinator(this._locale, this._display, this._reading);

  Future<void> resetAll() async {
    final box = Hive.box(AppConstants.mainAppSettingsBox);
    await box.clear();
    _locale.reload();
    _display.reload();
    _reading.reload();
  }
}
