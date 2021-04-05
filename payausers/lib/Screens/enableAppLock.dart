import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/custom_opt.dart';
import 'package:provider/provider.dart';

class SavingAppLock extends StatefulWidget {
  @override
  _SavingAppLockState createState() => _SavingAppLockState();
}

class _SavingAppLockState extends State<SavingAppLock> {
  @override
  Widget build(BuildContext context) {
    // Set Orientation to Portrait Mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    final themeChange = Provider.of<DarkThemeProvider>(context);

    // Setting Pass
    Future<void> settingAppLockPassString(String pass) async {
      final lStorage = FlutterSecureStorage();
      await lStorage.write(key: "local_lock", value: pass);
    }

    Future<String> validateUserPassword(String opt) async {
      await Future.delayed(Duration(milliseconds: 100));
      settingAppLockPassString(opt);
      return null;
    }

    void navigateToDashboard(context) {
      Navigator.pop(context);
      themeChange.appLock = true;
    }

    return CustomOtpScreen.withGradientBackground(
      validateOtp: validateUserPassword,
      routeCallback: navigateToDashboard,
      bottomColor: mainCTA,
      topColor: mainSectionCTA,
      otpLength: 4,
      themeColor: Colors.white,
      titleColor: Colors.white,
      title: "گذرواژه پشتیبان",
      subTitle:
          "گذرواژه ای را برای پشتیبانی در کنار تشخصی تصویر یا اثرانگشت تعیین کنید",
      icon: Lottie.asset("assets/lottie/faceIDWhite.json"),
    );
  }
}
