import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/custom_text.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:sizer/sizer.dart';

class CheckingAccess extends StatefulWidget {
  const CheckingAccess({Key key}) : super(key: key);

  @override
  _CheckingAccessState createState() => _CheckingAccessState();
}

class _CheckingAccessState extends State<CheckingAccess> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.0.h),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/checkingAccess.png",
                    width: 85.0.w,
                  ),
                ),
                SizedBox(height: 5.0.h),
                Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: t.translate("checkingAccess.accessDenied"),
                    size: titleTextSize,
                    weight: FontWeight.w500,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: t.translate("checkingAccess.visitHR"),
                    size: 18.0,
                  ),
                ),
                SizedBox(
                  height: 4.0.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(8.0),
                    color: mainCTA,
                    child: MaterialButton(
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () => exit(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: t.translate("checkingAccess.exitFromApp"),
                              color: Colors.white,
                              size: 20.0,
                            )
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
