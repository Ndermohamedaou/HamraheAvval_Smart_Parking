import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelReserve {
  Future<String> cancelUserReserve({token, userReserveID}) async {
    ApiAccess api = ApiAccess(token);
    try {
      Endpoint cancelReserveEndpoint =
          apiEndpointsMap["reserveEndpoint"]["cancelReserve"];
      return await api.requestHandler(
          "${cancelReserveEndpoint.route}?id=$userReserveID",
          cancelReserveEndpoint.method, {});
    } catch (e) {
      print("Error from Canceling Reserve $e");
      return "400";
    }
  }

  void delReserve({reserveID, context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");

    String caneclingResult =
        await cancelUserReserve(token: userToken, userReserveID: reserveID);

    if (caneclingResult == "200") {
      Navigator.pop(context);
      showStatusInCaseOfFlush(
          context: context,
          title: "لغو رزرو",
          msg: "لغو رزرو شما با موفقیت صورت گرفت",
          mainBackgroundColor: "#00c853",
          iconColor: Colors.white,
          icon: Icons.done_outline);
    } else if (caneclingResult == "500") {
      Navigator.pop(context);
      showStatusInCaseOfFlush(
          context: context,
          title: "حذف رزرو",
          msg: "این رزرو یک بار لغو شده است",
          iconColor: Colors.white,
          icon: Icons.warning);
    } else if (caneclingResult == "400")
      showStatusInCaseOfFlush(
          context: context,
          title: "حذف رزرو",
          msg: "حذف رزرو شما با مشکلی مواجه شده است، لطفا بعدا امتحان کنید",
          iconColor: Colors.white,
          icon: Icons.close);
  }
}
