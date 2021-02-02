import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/AlphabetClassList.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/miniPlate.dart';
import 'package:payausers/ExtractedWidgets/miniReserveHistory.dart';

AlphabetList alp = AlphabetList();

class ReservedTab extends StatelessWidget {
  const ReservedTab({this.mainThemeColor, this.reserves});

  final mainThemeColor;
  final List reserves;

  @override
  Widget build(BuildContext context) {
    // Change Lottie Background with dark/light theme
    var notThere = mainThemeColor.darkTheme
        ? "assets/lottie/reserve_dark.json"
        : "assets/lottie/reserve_light.json";

    // String rawPlate = reserves[0]["plate"];
    // var splitedPlate = rawPlate.split("-");
    // print("--------======-------");
    // print(splitedPlate[2].substring(0, 3));

    // print(alp.getAlp()["Sad"]);

    Widget emptyListManagerShower = Column(
      children: [
        Center(
            child: Container(
                margin: EdgeInsets.all(50),
                width: 250,
                height: 250,
                child: Lottie.asset(notThere))),
        Text(choseTime,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    Widget mainUserReserveHistory = ListView.builder(
      shrinkWrap: true,
      reverse: true,
      primary: false,
      itemCount: reserves.length != 0 ? reserves.length : 0,
      itemBuilder: (BuildContext context, index) {
        List perment = reserves[index]['plate'].split("-");
        return SingleChildScrollView(
          child: (Column(
            children: [
              MiniReserveHistory(
                plate0: "${perment[0]}",
                plate1: "${alp.getAlp()[perment[1]]}",
                plate2: "${perment[2].substring(0, 3)}",
                plate3: "${perment[2].substring(3, 5)}",
                status: reserves[index]['status'],
                buildingName: reserves[index]["building"] != null
                    ? reserves[index]["building"]
                    : "",
                startedTime: reserves[index]["reserveTimeStart"],
                endedTime: reserves[index]["reserveTimeEnd"],
                slotNo: reserves[index]["slot"],
              ),
            ],
          )),
        );
      },
    );

    final finalContext =
        reserves.isNotEmpty ? mainUserReserveHistory : emptyListManagerShower;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reserveTextTitle,
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: subTitleSize,
                          fontWeight: FontWeight.bold),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.blue, // button color
                        child: InkWell(
                          splashColor: Colors.blue[300], // inkwell color
                          child: SizedBox(
                              width: 46,
                              height: 46,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                          onTap: () =>
                              Navigator.pushNamed(context, "/reserveEditaion"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            finalContext
          ],
        ),
      ),
    );
  }
}
