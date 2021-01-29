import 'package:flutter/material.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void alertShowInDisplay({context, title, desc, Function action}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  Alert(
    context: context,
    type: AlertType.success,
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
