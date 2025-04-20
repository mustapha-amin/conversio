import 'package:conversio/services/theme_prefs.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = Themeprefs.getTheme();
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    Themeprefs.setTheme(_isDark);
    notifyListeners();
  }
}
