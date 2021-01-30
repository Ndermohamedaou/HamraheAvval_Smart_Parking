import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/miniPlate.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
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
        Lottie.asset("assets/lottie/searching.json"),
        Text(searchingProcessText,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    final plateContext = userTrafficLog.isEmpty ? searchingProcess : traffics;

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
