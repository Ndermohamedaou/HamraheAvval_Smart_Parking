import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'classes/SharedClass.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: themeChange.darkTheme
                    ? AssetImage("assets/images/haDark.png")
                    : AssetImage("assets/images/haLight.png"),
                scale: 1.5),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 300),
            child: SpinKitFadingCube(
              size: 25,
              color: themeChange.darkTheme
                  ? HexColor('#48C3CA')
                  : Colors.blue[700],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    final lStorage = FlutterSecureStorage();
    var uToken = await lStorage.read(key: "uToken");
    if (uToken != null) {
      Navigator.pushNamed(context, '/main');
    } else {
      Navigator.pushNamed(context, '/LoginPage');
    }
  }
}
