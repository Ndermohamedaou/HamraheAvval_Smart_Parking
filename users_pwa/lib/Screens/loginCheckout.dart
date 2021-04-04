import 'dart:async';

import 'package:flutter/material.dart';
import "package:sizer/sizer.dart";

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
          child: Image.network("assets/images/checkingOut.gif"),
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
