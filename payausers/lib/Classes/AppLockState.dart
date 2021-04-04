import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockPreferences {
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

class AppLockProvider with ChangeNotifier {
  AppLockPreferences appLockPreferences = AppLockPreferences();
  bool _appLock = false;

  bool get appLock => _appLock;

  set appLock(bool value) {
    _appLock = value;
    appLockPreferences.setLockAppState(value);
    notifyListeners();
  }
}
