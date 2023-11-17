import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOptions { light, dark }

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme(ThemeOptions themeOption) {
    switch (themeOption) {
      case ThemeOptions.light:
        themeMode = ThemeMode.light;
        break;
      case ThemeOptions.dark:
        themeMode = ThemeMode.dark;
        break;
    }
    saveThemeMode();
    notifyListeners();
  }

  void saveThemeMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('themeMode', themeMode.toString());

    var res = await pref.getString('themeMode');
    print(res);
  }

  Future<void> loadThemeMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final savedTheme = await pref.getString('themeMode');
    print(savedTheme);
    if (savedTheme != null) {
      themeMode = ThemeMode.values
          .firstWhere((element) => element.toString() == savedTheme);

      print("Theme mode is :${themeMode} ");
      notifyListeners();
    }
  }
}
