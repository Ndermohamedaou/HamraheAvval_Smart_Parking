import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startingTimer();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final mainTitleLogo = themeChange.darkTheme
        ? "assets/images/Titile_Logo_Mark_dark.png"
        : "assets/images/Titile_Logo_Mark_light.png";
    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              child: Image.asset(
                mainTitleLogo,
                width: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void startingTimer() {
    Timer(Duration(milliseconds: 1000), () {
      navigatedToRoot(); //It will redirect  after 5 microseconds
    });
  }

  void navigatedToRoot() async {
    final lStorage = FlutterSecureStorage();
    final userToken = await lStorage.read(key: "token");
    final local_auth_pasas = await lStorage.read(key: "local_lock");
    if (userToken != null) {
      if (local_auth_pasas != null) // And And our boolean lock status show
        Navigator.pushNamed(context, "/localAuth");
      else
        Navigator.pushNamed(context, "/dashboard");
    } else
      Navigator.pushNamed(context, '/');
  }
}
