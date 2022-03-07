import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbar_status.dart';

class CancelReserve {
  FlutterSecureStorage lds = FlutterSecureStorage();

  Future<Map> cancelUserReserve({token, userReserveID}) async {
    ApiAccess api = ApiAccess(token);
    // print(userReserveID);
    try {
      Endpoint cancelReserveEndpoint =
          apiEndpointsMap["reserveEndpoint"]["cancelReserve"];
      return await api.requestHandler(
          "${cancelReserveEndpoint.route}?id=$userReserveID",
          cancelReserveEndpoint.method, {});
    } catch (e) {
      // print("Error from Canceling Reserve $e");
      return {
        "status": "error",
        "message": {
          "title": "خطا در ارسال درخواست",
          "desc": "مشکلی در ارتباط با سرویس دهنده رخ داده است."
        }
      };
    }
  }

  void delReserve({reserveID, context}) async {
    final userToken = await lds.read(key: "token");
    final cancelResult =
        await cancelUserReserve(token: userToken, userReserveID: reserveID);

    // print(caneclingResult);

    if (cancelResult["status"] == "success") {
      Navigator.pop(context);
      showStatusInCaseOfFlush(
          context: context,
          mainBackgroundColor: "#00c853",
          title: cancelResult["message"]["title"],
          msg: cancelResult["message"]["desc"],
          iconColor: Colors.white,
          icon: Icons.done_outline);
    } else if (cancelResult["status"] == "warning") {
      Navigator.pop(context);
      showStatusInCaseOfFlush(
          context: context,
          title: cancelResult["message"]["title"],
          msg: cancelResult["message"]["desc"],
          mainBackgroundColor: Colors.orange,
          iconColor: Colors.white,
          icon: Icons.warning);
    } else if (cancelResult["status"] == "error")
      showStatusInCaseOfFlush(
          context: context,
          mainBackgroundColor: Colors.red,
          title: cancelResult["message"]["title"],
          msg: cancelResult["message"]["desc"],
          iconColor: Colors.white,
          icon: Icons.close);
  }
}
