import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/controller/alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DeletePlate {
  ApiAccess api = ApiAccess();
  FlutterSecureStorage lds = FlutterSecureStorage();

  Future<String> deleteUserPlateControl({token, plateID}) async {
    try {
      return await api.delUserPlate(token: token, id: plateID);
    } catch (e) {
      print("Error from Deleting user plate $e");
      return "400";
    }
  }

  // Deleting User Selected Plate
  void delUserPlate({id, context, themeChange}) async {
    final userToken = await lds.read(key: "token");
    final delStatus =
        await deleteUserPlateControl(token: userToken, plateID: id);
    if (delStatus == "200") {
      alert(
          context: context,
          aType: AlertType.success,
          title: delProcSucTitle,
          desc: delProcDesc,
          themeChange: themeChange,
          dstRoute: "dashboard");
    }
    if (delStatus == "400")
      alert(
          context: context,
          aType: AlertType.warning,
          title: delProcFailTitle,
          desc: delProcFailDesc,
          themeChange: themeChange,
          dstRoute: "dashboard");
  }
}
