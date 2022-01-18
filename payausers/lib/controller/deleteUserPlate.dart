import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DeletePlate {
  FlutterSecureStorage lds = FlutterSecureStorage();

  Future<String> deleteUserPlateControl({token, plateID}) async {
    ApiAccess api = ApiAccess(token);
    Endpoint deleteUserPlateEndpoint =
        apiEndpointsMap["plateEndpoint"]["delUserPlate"];
    try {
      return await api.requestHandler(
          "${deleteUserPlateEndpoint.route}?plate_en=$plateID",
          deleteUserPlateEndpoint.method, {});
    } catch (e) {
      print("Error from Deleting user plate $e");
      return "400";
    }
  }

  // Deleting User Selected Plate
  void delUserPlate({id, context}) async {
    final userToken = await lds.read(key: "token");
    final delStatus =
        await deleteUserPlateControl(token: userToken, plateID: id);

    // print(delStatus);

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
