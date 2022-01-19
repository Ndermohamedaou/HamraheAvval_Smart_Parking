import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/custom_local_auth.dart';

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

    checkBiometric().then((checkBiomatricAvailable) {
      print(checkBiomatricAvailable);
      if (checkBiomatricAvailable) {
        _authenticateWithBiometrics();
      } else
        return null;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> checkBiometric() async {
    return await auth.canCheckBiometrics;
  }

  Future<void> _authenticateWithBiometrics() async {
    await Future.delayed(Duration(seconds: 1));
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
      print("Erorr from auth because: $e");
      setState(() {
        isAuthenticating = false;
        authorized = "Error - ${e.message}";
      });
      return null;
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
          icon: Lottie.asset("assets/lottie/faceIDWhite.json"),
        ),
      ),
    );
  }
}
