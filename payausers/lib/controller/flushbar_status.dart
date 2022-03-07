import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

void showStatusInCaseOfFlush(
    {context,
    mainBackgroundColor = "#F38137",
    String msg,
    title,
    icon,
    iconColor}) {
  Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    backgroundColor: HexColor(mainBackgroundColor),
    flushbarPosition: FlushbarPosition.TOP,
    titleText: Text(
      title,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
          fontFamily: mainFaFontFamily,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    ),
    messageText: Text(
      msg,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(fontFamily: mainFaFontFamily, color: Colors.white),
    ),
    icon: Icon(
      icon,
      size: 28.0,
      color: iconColor,
      textDirection: TextDirection.ltr,
    ),
    duration: Duration(seconds: 10),
  ).show(context);
}

void showStatusInCaseOfFlushBottom(
    {context, String msg, title, icon, iconColor}) {
  Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    backgroundColor: mainSectionCTA,
    flushbarPosition: FlushbarPosition.BOTTOM,
    titleText: Text(
      title,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
          fontFamily: mainFaFontFamily,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    ),
    messageText: Text(
      msg,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(fontFamily: mainFaFontFamily, color: Colors.white),
    ),
    icon: Icon(
      icon,
      size: 28.0,
      color: iconColor,
      textDirection: TextDirection.ltr,
    ),
    duration: Duration(seconds: 10),
  ).show(context);
}
