import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';

class LoginCheckingoutPage extends StatefulWidget {
  @override
  _LoginCheckingoutPageState createState() => _LoginCheckingoutPageState();
}

class _LoginCheckingoutPageState extends State<LoginCheckingoutPage> {
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            mainTitleLogo,
            width: 200,
          ),
        ),
      ),
    );
  }

  void startingTimer() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushNamed(
          context, "/dashboard"); //It will redirect  after 4 seconds
    });
  }
}
