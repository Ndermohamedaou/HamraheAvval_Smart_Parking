import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payausers/Model/ApiAccess.dart';
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
    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/mainLogo.png"),
            ),
          ),
        ),
      ),
    );
  }

  void startingTimer() {
    Timer(Duration(seconds: 1), () {
      navigatedToRoot(); //It will redirect  after 5 microseconds
    });
  }

  void navigatedToRoot() async {
    ApiAccess api = ApiAccess();
    final lStorage = FlutterSecureStorage();
    final userToken = await lStorage.read(key: "token");
    final localAuthPasas = await lStorage.read(key: "local_lock");

    if (userToken != null) {
      // try {
      // Getting data from api Access
      // final userAccountStatus =
      // await api.getUserStatusAccount(token: userToken);
      // if (userAccountStatus['status'] != "disable") {
      if (localAuthPasas != null) // And And our boolean lock status show
        Navigator.pushNamed(context, "/localAuth");
      else
        Navigator.pushNamed(context, "/dashboard");
      // } else {
      // user is not active
      // }
      // } catch (e) {
      // Network or API Error
      // Navigator.pushNamed(context, '/checkConnection');
      // print("Error form getting status of user for entring dashboard $e");
      // }
    } else
      Navigator.pushNamed(context, '/');
  }
}
