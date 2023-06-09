import 'package:conversio/pallette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData(bool isDark, BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isDark
          ? AppColors.darkScaffoldBgColor
          : AppColors.lightScaffoldBgColor,
      primaryColor: AppColors.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      )),
      appBarTheme: const AppBarTheme(elevation: 0.0),
      dialogTheme: DialogTheme(
        backgroundColor: isDark
            ? AppColors.darkScaffoldBgColor
            : AppColors.lightScaffoldBgColor,
      ),
    );
  }
}
