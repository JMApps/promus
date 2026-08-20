import 'package:flutter/widgets.dart';

import '../enums/app_theme_mode.dart';

extension AppThemeModeX on AppThemeMode {
  String title(BuildContext context) {
    switch (this) {
      case AppThemeMode.system:
        return 'Системная';

      case AppThemeMode.light:
        return 'Светлая';

      case AppThemeMode.dark:
        return 'Тёмная';
    }
  }
}
