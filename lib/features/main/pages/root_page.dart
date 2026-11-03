import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../state/main_settings_state.dart';
import 'home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final (mode, color) = context.select<MainSettingsState, (ThemeMode, Color)>(
          (s) => (s.themeMode, s.themeColor),
    );
    final appTheme = AppTheme(seedColor: color);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      themeMode: mode,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      onGenerateRoute: AppRoutes.onRouteGenerator,
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      builder: (context, child) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: Platform.isAndroid,
          maintainBottomViewPadding: true,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      home: const HomePage(),
    );
  }
}
