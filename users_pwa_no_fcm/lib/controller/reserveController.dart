import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../ConstFiles/constText.dart';

void reserveMe({st, et, context, bool themeChange}) async {
  if (st != "" && et != "") {
    ApiAccess api = ApiAccess();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = await prefs.getString("token");
    try {
      String reserveResult =
          await api.reserveByUser(token: userToken, startTime: st, endTime: et);
      // print("$reserveResult");
      if (reserveResult == "200") {
        rAlert(
            context: context,
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
            tAlert: AlertType.success,
            title: titleOfReserve,
            desc: resultOfReserve);
      } else if (reserveResult == "AlreadyReserved") {
        rAlert(
            context: context,
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
            tAlert: AlertType.warning,
            title: titleOfFailedReserve,
            desc: descOfFailedReserve);
      }
    } catch (e) {
      Toast.show(dataEntryInCorrect, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
    }
  } else
    Toast.show(dataEntryInCorrect, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        textColor: Colors.white);
}
