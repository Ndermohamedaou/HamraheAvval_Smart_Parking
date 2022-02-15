import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelReserve {
  Future<Map> cancelUserReserve({token, userReserveID}) async {
    ApiAccess api = ApiAccess(token);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");

    final cancelResult =
        await cancelUserReserve(token: userToken, userReserveID: reserveID);

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
