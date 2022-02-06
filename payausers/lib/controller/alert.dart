import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

void rAlert({context, title, desc, tAlert, onTapped}) {
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
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: mainFaFontFamily),
        ),
        onPressed: onTapped,
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
      builder: (_) {
        DarkThemeProvider themeChange = Provider.of<DarkThemeProvider>(context);
        return Dialog(
          backgroundColor:
              themeChange.darkTheme ? mainBgColorDark : mainBgColorLight,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: EdgeInsets.all(20),
            width: 80.0.w,
            height: 100.0.w,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 100,
                  height: 100,
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
                  style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  textDirection: TextDirection.rtl,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(8.0),
                        color: mainSectionCTA,
                        child: MaterialButton(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: acceptPressed,
                            child: Text(
                              "بله",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: loginBtnTxtColor,
                                  fontFamily: mainFaFontFamily,
                                  fontSize: btnSized,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(8.0),
                        color: themeChange.darkTheme ? darkBar : Colors.white,
                        child: MaterialButton(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "خیر",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainSectionCTA,
                                  fontFamily: mainFaFontFamily,
                                  fontSize: btnSized,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
