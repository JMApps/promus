import 'package:flutter/material.dart';

import '../constants/font_families.dart';
import 'app_radius.dart';

class AppTheme {
  final Color seedColor;

  AppTheme({required this.seedColor});

  late final ThemeData lightTheme = _buildTheme(Brightness.light);
  late final ThemeData darkTheme  = _buildTheme(Brightness.dark);

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: seedColor,
    );
    return ThemeData(
      fontFamily: FontFamilies.ptSans,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        dragHandleSize: Size(100, 4),
        showDragHandle: true,
      ),
      cardTheme: const CardThemeData(
        margin: .zero,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.medium,
          border: .all(
            width: 1.0,
            color: colorScheme.primary,
          ),
        ),
        textStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
