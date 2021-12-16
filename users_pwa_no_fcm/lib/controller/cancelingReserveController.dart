import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelReserve {
  ApiAccess api = ApiAccess();

  Future<String> cancelUserReserve({token, userReserveID}) async {
    try {
      return await api.cancelingReserve(token: token, reservID: userReserveID);
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
          iconColor: Colors.green,
          icon: Icons.done_outline);
    } else if (caneclingResult == "500") {
      Navigator.pop(context);
      showStatusInCaseOfFlush(
          context: context,
          title: "حذف رزرو",
          msg: "این رزرو یک بار لغو شده است",
          iconColor: Colors.orange,
          icon: Icons.warning);
    } else if (caneclingResult == "400")
      showStatusInCaseOfFlush(
          context: context,
          title: "حذف رزرو",
          msg: "حذف رزرو شما با مشکلی مواجه شده است، لطفا بعدا امتحان کنید",
          iconColor: Colors.red,
          icon: Icons.close);
  }
}
