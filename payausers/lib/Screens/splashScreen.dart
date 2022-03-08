import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/ExtractedWidgets/custom_text.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/public_parking_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
    AppLocalizations t = AppLocalizations.of(context);
    staffInfoModel = Provider.of<StaffInfoModel>(context);
    publicParkingModel = Provider.of<PublicParkingModel>(context);

    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0.h),
                Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/mainLogo.png"),
                  ),
                ),
                SizedBox(height: 15.0.h),
                Container(
                  alignment: Alignment.center,
                  child: Column(children: [
                    Image(
                      image: AssetImage("assets/images/cardLogo.png"),
                      width: 10.0.w,
                    ),
                    SizedBox(height: 2.0.h),
                    CustomText(
                      text: t.translate("appNameSubTitle"),
                      size: 12.0,
                      align: TextAlign.center,
                      weight: FontWeight.w500,
                    )
                  ]),
                ),
              ],
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
