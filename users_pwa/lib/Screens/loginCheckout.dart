import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/providers/public_parking_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Widget build(BuildContext context) {
    publicParkingModel = Provider.of<PublicParkingModel>(context);

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

  void startingTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("avatar");
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
