import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'dart:ui';

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
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      // primaryColor: isDarkTheme ? HexColor('#f2f2f2') : HexColor('#F9F9F9'),
      backgroundColor: isDarkTheme ? lightBgColor : darkBgColor,
      scaffoldBackgroundColor: isDarkTheme ? darkBgColor : lightBgColor,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      // canvasColor: isDarkTheme ? HexColor('#f2f2f2') : HexColor('#f2f2f2'),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      // appBarTheme: AppBarTheme(
      //   color: mainBgColorLight,
      //   elevation: 0.0,
      // ),
    );
  }
}
