import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import 'home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(seedColor: Colors.amber);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      builder: (context, child) {
        return SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: Platform.isAndroid,
          maintainBottomViewPadding: true,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomePage(),
    );
  }
}
