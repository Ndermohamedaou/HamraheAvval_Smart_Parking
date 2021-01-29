import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void alertShowInDisplay({context, title, desc, Function action, curTheme}) {
  Alert(
    context: context,
    type: AlertType.success,
    title: title,
    desc: desc,
    style: AlertStyle(
        backgroundColor: curTheme ? darkBar : Colors.white,
        titleStyle: TextStyle(
          fontFamily: mainFaFontFamily,
        ),
        descStyle: TextStyle(fontFamily: mainFaFontFamily)),
    buttons: [
      DialogButton(
        child: Text(
          "تایید",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: mainFaFontFamily),
        ),
        onPressed: action,
        width: 120,
      )
    ],
  ).show();
}
