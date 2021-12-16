import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/controller/alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeletePlate {
  ApiAccess api = ApiAccess();

  Future<String> deleteUserPlateControl({token, plateID}) async {
    try {
      return await api.delUserPlate(token: token, id: plateID);
    } catch (e) {
      print("Error from Deleting user plate $e");
      return "400";
    }
  }

  // Deleting User Selected Plate
  void delUserPlate({id, context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");

    final delStatus =
        await deleteUserPlateControl(token: userToken, plateID: id);

    print(delStatus);

    if (delStatus == "200") {
      rAlert(
        context: context,
        tAlert: AlertType.success,
        title: delProcSucTitle,
        desc: delProcDesc,
        onTapped: () =>
            Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
      );
    }
    if (delStatus == "400")
      rAlert(
        context: context,
        tAlert: AlertType.warning,
        title: delProcFailTitle,
        desc: delProcFailDesc,
        onTapped: () =>
            Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
      );
  }
}
