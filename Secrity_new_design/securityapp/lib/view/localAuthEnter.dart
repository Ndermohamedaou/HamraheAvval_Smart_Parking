import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/custom_opt.dart';

class LocalAuthEnter extends StatefulWidget {
  @override
  _LocalAuthEnterState createState() => _LocalAuthEnterState();
}

class _LocalAuthEnterState extends State<LocalAuthEnter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> validateUserPassword(String opt) async {
    await Future.delayed(Duration(milliseconds: 100));
    // Getting password from Flutter local (secure) Storage
    final lStorage = FlutterSecureStorage();
    final localAuthAppLockPass = await lStorage.read(key: "local_lock");

    if (opt == localAuthAppLockPass)
      return null;
    else
      return "گذرواژه اشتباه است";
  }

  void navigateToDashboard(context) {
    Navigator.pushNamed(context, mainoRoute);
  }

  @override
  Widget build(BuildContext context) {
    // Set Orientation to Portrait Mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      // backgroundColor: Colors.red
      body: WillPopScope(
        onWillPop: () =>
            SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
        child: CustomOtpScreen.withGradientBackground(
          validateOtp: validateUserPassword,
          routeCallback: navigateToDashboard,
          bottomColor: mainCTA,
          topColor: mainSectionCTA,
          otpLength: 4,
          themeColor: Colors.white,
          titleColor: Colors.white,
          title: "پارکینگ من",
          subTitle: "گذرواژه ورود به اپلیکیشن را وارد نمایید",
          icon: Lottie.asset("assets/animation/faceIDWhite.json"),
        ),
      ),
    );
  }
}
