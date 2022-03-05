import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/providers/public_parking_model.dart';
import 'package:provider/provider.dart';

class LoginCheckingoutPage extends StatefulWidget {
  @override
  _LoginCheckingoutPageState createState() => _LoginCheckingoutPageState();
}

class _LoginCheckingoutPageState extends State<LoginCheckingoutPage> {
  PublicParkingModel publicParkingModel;

  @override
  void initState() {
    super.initState();
    startingTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    publicParkingModel = Provider.of<PublicParkingModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Lottie.asset("assets/lottie/checkLogin.json", repeat: false),
        ),
      ),
    );
  }

  startingTimer() async {
    final lStorage = FlutterSecureStorage();
    String userToken = await lStorage.read(key: "token");
    ApiAccess api = ApiAccess(userToken);

    try {
      Endpoint staffInfo = apiEndpointsMap["auth"]["staffInfo"];
      final staffInfoMap =
          await api.requestHandler(staffInfo.route, staffInfo.method, {});
      int parkingType = staffInfoMap["parking_type"];

      if (parkingType == 0) {
        publicParkingModel.fetchPublicParking;
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushNamed(context, "/selectParkingType");
      } else {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushNamed(context, "/dashboard");
      }
    } catch (e) {
      print("Error in getting data of staff info in splash screen $e");
      Navigator.pushNamed(context, '/checkConnection');
    }
  }
}
