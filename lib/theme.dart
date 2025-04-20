import 'package:conversio/pallette.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  static ThemeData themeData(bool isDark, BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor:
          isDark
              ? AppColors.darkScaffoldBgColor
              : AppColors.lightScaffoldBgColor,
      primaryColor: AppColors.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        titleTextStyle: kTextStyle(context: context, size: 18),
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      dialogTheme: DialogTheme(
        backgroundColor:
            isDark
                ? AppColors.darkScaffoldBgColor
                : AppColors.lightScaffoldBgColor,
      ),
    );
  }
}
