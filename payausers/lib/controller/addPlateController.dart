import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/controller/alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

void sendNewUserPlate(p0, p1, p2, p3, context, themeChange, dst) async {
  if (p0.length == 2 && p2.length == 3 && p3.length == 2) {
    List orderedPlate = [p0, p1, p2, p3];
    ApiAccess api = ApiAccess();
    FlutterSecureStorage lds = FlutterSecureStorage();
    // print("This is from App method => ${orderedPlate[3]}");
    final uToken = await lds.read(key: "token");
    try {
      // String result =
      //     await api.addUserPlate(token: uToken, lsPlate: orderedPlate);
      String result;
      if (result == "MaxPlateCount") {
        alert(
            aType: AlertType.warning,
            title: warnningOnAddPlate,
            desc: moreThanPlateAdded,
            context: context,
            themeChange: themeChange,
            dstRoute: dst);
      }
      if (result == "PlateExists") {
        alert(
            aType: AlertType.error,
            title: existUserPlateTitleErr,
            desc: existUserPlateDescErr,
            context: context,
            themeChange: themeChange,
            dstRoute: dst);
      }
      if (result == "200") {
        alert(
            aType: AlertType.success,
            title: successAlert,
            desc: userPlateAdded,
            context: context,
            themeChange: themeChange,
            dstRoute: dst);
      }
    } catch (e) {
      Toast.show(serverNotRespondToAdd, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
    }
  } else {
    Toast.show(unCorrectPlateNumber, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        textColor: Colors.white);
  }
}
