import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreferences {
  final theme_status = "THEME_STATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(theme_status, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(theme_status) ?? false;
  }

  // Getting lock state in application
  setLockAppState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("lock_state", value);
  }

  Future<bool> getLockState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("lock_state") ?? false;
  }
}

// whenever we use dark UI theme changed
class DarkThemeProvider with ChangeNotifier {
  DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }

  bool _appLock = false;

  bool get appLock => _appLock;

  set appLock(bool value) {
    _appLock = value;
    darkThemePreferences.setLockAppState(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      // primaryColor: isDarkTheme ? HexColor('#f2f2f2') : HexColor('#F9F9F9'),
      backgroundColor: isDarkTheme ? mainBgColorLight : mainBgColorDark,
      scaffoldBackgroundColor: isDarkTheme ? mainBgColorDark : mainBgColorLight,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      // canvasColor: isDarkTheme ? HexColor('#f2f2f2') : HexColor('#f2f2f2'),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      appBarTheme: AppBarTheme(
        color: mainBgColorLight,
        elevation: 0.0,
      ),
    );
  }
}
