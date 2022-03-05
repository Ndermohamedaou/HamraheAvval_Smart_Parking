import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/providers/public_parking_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StaffInfoModel staffInfoModel;
  PublicParkingModel publicParkingModel;

  @override
  void initState() {
    super.initState();
    startingTimer();
  }

  @override
  Widget build(BuildContext context) {
    staffInfoModel = Provider.of<StaffInfoModel>(context);
    publicParkingModel = Provider.of<PublicParkingModel>(context);

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
      navigatedToRoot();
    });
  }

  void navigatedToRoot() async {
    ///
    /// Will navigate to proper screen, at first getting user token
    /// if user token was null, will show login screen, else will decide to show
    /// parking ty[e view or dashboard view.
    final lStorage = FlutterSecureStorage();
    String userToken = await lStorage.read(key: "token");
    final localAuth = await lStorage.read(key: "local_lock");
    ApiAccess api = ApiAccess(userToken);

    if (userToken != null) {
      try {
        Endpoint staffInfo = apiEndpointsMap["auth"]["staffInfo"];
        final staffInfoMap =
            await api.requestHandler(staffInfo.route, staffInfo.method, {});
        int parkingType = staffInfoMap["parking_type"];

        if (localAuth != null) {
          Navigator.pushNamed(context, "/localAuth");
        } else {
          if (parkingType == 0) {
            publicParkingModel.fetchPublicParking;
            Navigator.pushNamed(context, "/selectParkingType");
          } else {
            Navigator.pushNamed(context, "/dashboard");
          }
        }
      } catch (e) {
        print("Error in getting data of staff info in splash screen $e");
        Navigator.pushNamed(context, '/checkConnection');
      }
    } else {
      Navigator.pushNamed(context, '/');
    }
  }
}
