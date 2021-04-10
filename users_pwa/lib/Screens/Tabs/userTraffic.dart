import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/miniPlate.dart';
import 'package:provider/provider.dart';

class UserTraffic extends StatelessWidget {
  const UserTraffic({this.userTrafficLog});

  final List userTrafficLog;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Widget traffics = Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: userTrafficLog.length,
          primary: false,
          itemBuilder: (BuildContext context, index) {
            return (Column(
              children: [
                MiniPlate(
                  plate0: userTrafficLog[index]["plate0"],
                  plate1: userTrafficLog[index]["plate1"],
                  plate2: userTrafficLog[index]["plate2"],
                  plate3: userTrafficLog[index]["plate3"],
                  buildingName: userTrafficLog[index]["building"] != null
                      ? userTrafficLog[index]["building"]
                      : "",
                  startedTime: userTrafficLog[index]["entry_datetime"],
                  endedTime: userTrafficLog[index]["exit_datetime"],
                  slotNo: userTrafficLog[index]["slot"],
                ),
              ],
            ));
          },
        ),
      ],
    );

    Widget searchingProcess = Column(
      children: [
        Image.asset(
          "assets/images/loading.gif",
          width: 40.0.w,
        ),
        Text(userTrafficNull,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    final plateContext =
        userTrafficLog.length == 0 ? searchingProcess : traffics;

    // print(userTrafficLog);

    // print(userTrafficLog.length);
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    trafficsLogText,
                    style: TextStyle(
                        fontFamily: mainFaFontFamily, fontSize: subTitleSize),
                  ),
                ),
              ],
            ),
          ),
          plateContext,
        ],
      ),
    ));
  }
}
