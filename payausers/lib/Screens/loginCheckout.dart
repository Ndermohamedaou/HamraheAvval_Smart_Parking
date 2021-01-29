import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginCheckingoutPage extends StatefulWidget {
  @override
  _LoginCheckingoutPageState createState() => _LoginCheckingoutPageState();
}

class _LoginCheckingoutPageState extends State<LoginCheckingoutPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startingTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Lottie.asset("assets/lottie/checkLogin.json"),
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
