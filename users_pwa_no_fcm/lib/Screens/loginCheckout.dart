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
    Timer(Duration(seconds: 2), () {
      Navigator.pushNamed(
          context, "/dashboard"); //It will redirect  after 4 seconds
    });
  }
}
