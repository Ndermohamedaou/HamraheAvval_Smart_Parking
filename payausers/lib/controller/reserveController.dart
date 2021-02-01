import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

Future<List> gettingMyPlates() async {
  ApiAccess api = ApiAccess();
  FlutterSecureStorage lds = FlutterSecureStorage();
  final userToken = await lds.read(key: "token");
  final plates = await api.getUserPlate(token: userToken);
  return plates;
}

// TODO Check this alert to show it to users
void alert({bool themeChange, context, title, desc}) {
  Alert(
    context: context,
    type: AlertType.success,
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
      if (reserveResult == "200") {
        // print("======$reserveResult======");
        alert(
            context: context,
            themeChange: themeChange,
            title: titleOfReserve,
            desc: resultOfReserve);
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
