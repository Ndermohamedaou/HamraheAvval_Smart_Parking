import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

void rAlert({bool themeChange, context, title, desc, tAlert, dstRoute}) {
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
        color: mainCTA,
        child: Text(
          "تایید",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: mainFaFontFamily),
        ),
        onPressed: () =>
            Navigator.popUntil(context, ModalRoute.withName(dstRoute)),
        width: 120,
      )
    ],
  ).show();
}

void customAlert(
    {context,
    title,
    desc,
    alertIcon,
    iconColor,
    borderColor,
    acceptPressed,
    ignorePressed}) {
  showDialog(
      context: context,
      builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: EdgeInsets.all(20),
              width: 100.0.w,
              height: 100.0.w,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Icon(
                      alertIcon,
                      size: 10.0.h,
                      color: iconColor,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: mainFaFontFamily,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    desc,
                    style:
                        TextStyle(fontFamily: mainFaFontFamily, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    textDirection: TextDirection.rtl,
                    children: [
                      DialogButton(
                        color: Colors.green,
                        child: Text(
                          "تایید",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: mainFaFontFamily),
                        ),
                        onPressed: acceptPressed,
                        width: 25.0.w,
                      ),
                      DialogButton(
                        color: Colors.red,
                        child: Text(
                          "خير",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: mainFaFontFamily),
                        ),
                        onPressed: ignorePressed,
                        width: 25.0.w,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
}

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
