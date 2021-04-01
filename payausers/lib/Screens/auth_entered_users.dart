import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/custom_opt.dart';

class LocalAuthEnter extends StatefulWidget {
  @override
  _LocalAuthEnterState createState() => _LocalAuthEnterState();
}

class _LocalAuthEnterState extends State<LocalAuthEnter> {
  final LocalAuthentication auth = LocalAuthentication();
  String authorized = "NotAuthorized";
  bool isAuthenticating = false;
  // Getting decision to Navigate into Dashboard
  bool gettingStart = false;

  @override
  void initState() {
    super.initState();

    _authenticateWithBiometrics();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        isAuthenticating = true;
        authorized = 'Authenticating';
      });
      // Main Process
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
        sensitiveTransaction: true,
      );

      setState(() {
        isAuthenticating = false;
        authorized = 'Authenticating';
      });
      if (authenticated) Navigator.pushNamed(context, "/dashboard");
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        isAuthenticating = false;
        authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'NotAuthorized';
    final bool didAuthenticated = authenticated ? true : false;
    setState(() {
      authorized = message;
      gettingStart = didAuthenticated;
    });
  }

  Future<String> validateUserPassword(String opt) async {
    await Future.delayed(Duration(milliseconds: 2000));
    // Getting password from Flutter local (secure) Storage
    final lStorage = FlutterSecureStorage();
    final localAuthAppLockPass = await lStorage.read(key: "local_lock");

    if (opt == localAuthAppLockPass)
      return null;
    else
      return "گذرواژه اشتباه است";
  }

  void navigateToDashboard(context) {
    Navigator.pushNamed(context, "/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.redz,
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
          icon: Lottie.asset("assets/lottie/faceIDWhite.json"),
        ),
      ),
    );
  }
}
