import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void alert({context, title, desc, aType, themeChange, dstRoute, tAlert}) {
  Alert(
    context: context,
    type: aType,
    title: title,
    desc: desc,
    style: AlertStyle(
        backgroundColor: themeChange.darkTheme ? darkBar : Colors.white,
        titleStyle: TextStyle(
          fontFamily: mainFaFontFamily,
        ),
        descStyle: TextStyle(fontFamily: mainFaFontFamily)),
    buttons: [
      DialogButton(
        child: Text(
          submitTextForAlert,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: mainFaFontFamily),
        ),
        onPressed: () => dstRoute != ""
            ? Navigator.popUntil(context, ModalRoute.withName("/$dstRoute"))
            : Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
        width: 120,
      )
    ],
  ).show();
}
