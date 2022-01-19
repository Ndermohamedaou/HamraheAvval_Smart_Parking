import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("assets/images/mainLogo.png"),
          ),
        ),
      ),
    );
  }

  void startingTimer() {
    Timer(Duration(seconds: 1), () {
      navigatedToRoot(); //It will redirect  after 1 second
    });
  }

  void navigatedToRoot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");
    if (userToken != null)
      Navigator.pushNamed(context, "/dashboard");
    else
      Navigator.pushNamed(context, '/');
  }
}
