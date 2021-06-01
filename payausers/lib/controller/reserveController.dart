import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

import '../ConstFiles/constText.dart';

Future<List> gettingMyPlates() async {
  ApiAccess api = ApiAccess();
  FlutterSecureStorage lds = FlutterSecureStorage();
  final userToken = await lds.read(key: "token");
  final plates = await api.getUserPlate(token: userToken);
  return plates;
}

void alert({bool themeChange, context, title, desc, tAlert}) {
  Alert(
    context: context,
    type: tAlert,
    title: title,
    desc: desc,
    style: AlertStyle(
        // backgroundColor: themeChange.darkTheme ? darkBar : Colors.white,
        titleStyle: TextStyle(
          fontFamily: mainFaFontFamily,
        ),
        descStyle: TextStyle(fontFamily: mainFaFontFamily)),
    buttons: [
      DialogButton(
        child: Text(
          "تایید",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: mainFaFontFamily),
        ),
        onPressed: () =>
            Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
        width: 120,
      )
    ],
  ).show();
}

void reserveMe({st, et, pt, context, bool themeChange}) async {
  if (st != "" && et != "" && pt != "") {
    ApiAccess api = ApiAccess();
    FlutterSecureStorage lds = FlutterSecureStorage();
    final userToken = await lds.read(key: "token");
    try {
      String reserveResult = await api.reserveByUser(
          token: userToken, startTime: st, endTime: et, plateNo: pt);
      // print("$reserveResult");
      if (reserveResult == "200") {
        alert(
            context: context,
            themeChange: themeChange,
            tAlert: AlertType.success,
            title: titleOfReserve,
            desc: resultOfReserve);
      } else if (reserveResult == "AlreadyReserved") {
        alert(
            context: context,
            tAlert: AlertType.warning,
            themeChange: themeChange,
            title: titleOfFailedReserve,
            desc: descOfFailedReserve);
      }
    } catch (e) {
      Toast.show(dataEntryUnCorrect, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
    }
  } else
    Toast.show(dataEntryUnCorrect, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        textColor: Colors.white);
}
