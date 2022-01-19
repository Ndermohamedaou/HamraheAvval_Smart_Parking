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
  // Saving notification number badge for user plate
  setUserPlateNotifNumber(int notifNumValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("user_plate_notif_number", notifNumValue);
  }

  Future<int> getUserPlateNotifNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_plate_notif_number") ?? 0;
  }

  // Saving notification number badge for user instant reserve
  setInstantUserReserveNotifNumber(int notifNumValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("instant_reserve_notif_number", notifNumValue);
  }

  Future<int> getInstantUserNotifNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("instant_reserve_notif_number") ?? 0;
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

  // Notification number for user plate
  int _userPlateNotif = 0;

  int get userPlateNumNotif => _userPlateNotif;

  set userPlateNumNotif(int notifNumValue) {
    _userPlateNotif = notifNumValue;
    darkThemePreferences.setUserPlateNotifNumber(notifNumValue);
    notifyListeners();
  }

  // Notification number for user Instant reserve
  int _instantReserve = 0;

  int get instantUserReserve => _instantReserve;

  set instantUserReserve(int notifNumValue) {
    _instantReserve = notifNumValue;
    darkThemePreferences.setInstantUserReserveNotifNumber(notifNumValue);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    MaterialColor materialSwatchWhite = MaterialColor(
      0xFFFFFFFF,
      const <int, Color>{
        50: const Color(0xFFFFFFFF),
        100: const Color(0xFFFFFFFF),
        200: const Color(0xFFFFFFFF),
        300: const Color(0xFFFFFFFF),
        400: const Color(0xFFFFFFFF),
        500: const Color(0xFFFFFFFF),
        600: const Color(0xFFFFFFFF),
        700: const Color(0xFFFFFFFF),
        800: const Color(0xFFFFFFFF),
        900: const Color(0xFFFFFFFF),
      },
    );
    MaterialColor materialSwatchBlack = MaterialColor(
      0xFF000000,
      const <int, Color>{
        50: const Color(0xFF000000),
        100: const Color(0xFF000000),
        200: const Color(0xFF000000),
        300: const Color(0xFF000000),
        400: const Color(0xFF000000),
        500: const Color(0xFF000000),
        600: const Color(0xFF000000),
        700: const Color(0xFF000000),
        800: const Color(0xFF000000),
        900: const Color(0xFF000000),
      },
    );
    return ThemeData(
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? mainBgColorLight : mainBgColorDark,
      scaffoldBackgroundColor: isDarkTheme ? mainBgColorDark : mainBgColorLight,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      // Action button color and some cursors
      primarySwatch: isDarkTheme ? materialSwatchWhite : materialSwatchBlack,
      // AppBar Title TextColor
      primaryTextTheme: TextTheme(
          headline6:
              TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),

      appBarTheme: AppBarTheme(
        color: isDarkTheme ? mainBgColorDark : mainBgColorLight,
        elevation: 0.0,
      ),
    );
  }
}
