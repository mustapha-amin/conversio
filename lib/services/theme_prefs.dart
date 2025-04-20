import 'package:shared_preferences/shared_preferences.dart';

class Themeprefs {
  static SharedPreferences? sharedPreferences;


  static initThemeSettings() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool getTheme() {
    return sharedPreferences!.getBool('theme') ?? false;
  }

  static setTheme(bool value) async {
    await sharedPreferences!.setBool('theme', value);
  }
}
