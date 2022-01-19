import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbarStatus.dart';

class CancelReserve {
  FlutterSecureStorage lds = FlutterSecureStorage();

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
    final userToken = await lds.read(key: "token");
    String caneclingResult =
        await cancelUserReserve(token: userToken, userReserveID: reserveID);

    if (caneclingResult == "200") {
      Navigator.pop(context);
      showStatusInCaseOfFlush(
          context: context,
          mainBackgroundColor: "#00c853",
          title: "لغو رزرو",
          msg: "لغو رزرو شما با موفقیت صورت گرفت",
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
