import 'dart:async';

import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    startingTimer();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final mainTitleLogo = themeChange.darkTheme
        ? "assets/images/Titile_Logo_Mark_dark.png"
        : "assets/images/Titile_Logo_Mark_light.png";
    return Scaffold(
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
    );
  }

  void startingTimer() {
    Timer(Duration(microseconds: 5), () {
      navigatedToRoot(); //It will redirect  after 5 microseconds
    });
  }

  void navigatedToRoot() async {
    final lStorage = FlutterSecureStorage();
    final userToken = await lStorage.read(key: "token");
    if (userToken != null)
      Navigator.pushNamed(context, "/dashboard");
    else
      Navigator.pushNamed(context, '/');
  }
}
