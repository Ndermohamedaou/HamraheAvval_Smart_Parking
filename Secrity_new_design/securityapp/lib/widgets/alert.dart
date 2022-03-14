import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

void alertCheckTip({context, Function onPressed}) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: attentionInSendingData,
    style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          fontFamily: mainFont,
          color: Colors.black,
        ),
        descStyle: TextStyle(fontFamily: mainFont)),
    buttons: [
      DialogButton(
        child: CustomText(
          text: understandingMater,
          align: TextAlign.center,
          size: 15.0.sp,
        ),
        onPressed: onPressed,
      ),
    ],
  ).show();
}

securityAlertLogin({context, Function onPressed}) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "ورود به اپلیکیشن فقط برای انتظامات می باشد نه برای کاربران عادی ",
    style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          fontFamily: mainFont,
          color: Colors.black,
        ),
        descStyle: TextStyle(fontFamily: mainFont)),
    buttons: [
      DialogButton(
        child: CustomText(
          text: understandingMater,
          align: TextAlign.center,
          size: 15.0.sp,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    ],
  ).show();
}

void rAlert({context, title, desc, tAlert, onTapped}) {
  Alert(
    context: context,
    type: tAlert,
    title: title,
    desc: desc,
    style: AlertStyle(
        titleStyle: TextStyle(
          fontFamily: mainFont,
        ),
        descStyle: TextStyle(fontFamily: mainFont)),
    buttons: [
      DialogButton(
        color: mainCTA,
        child: Text(
          "تایید",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: mainFont),
        ),
        onPressed: onTapped,
        width: 120,
      )
    ],
  ).show();
}

void alertSayStatus({context}) {
  Alert(
    context: context,
    type: AlertType.success,
    title: savedSuccessFull,
    style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          fontFamily: mainFont,
          color: Colors.black,
        ),
        descStyle: TextStyle(fontFamily: mainFont)),
    buttons: [
      DialogButton(
        child: Text(
          savedSuccessBtn,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: mainFont,
          ),
        ),
        onPressed: () =>
            Navigator.popUntil(context, ModalRoute.withName(mainoRoute)),
        width: 120,
      ),
    ],
  ).show();
}
