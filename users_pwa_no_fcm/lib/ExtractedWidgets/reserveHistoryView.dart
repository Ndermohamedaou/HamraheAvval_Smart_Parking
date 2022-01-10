import 'package:flutter/material.dart';
import 'package:payausers/Model/ReserveColorsStatus.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';

class ReserveHistoryView extends StatelessWidget {
  const ReserveHistoryView({
    this.reserveStatusColor,
    this.historyBuildingName,
    this.historySlotName,
    this.historyStartTime,
    this.historyEndTime,
    this.onPressed,
  });

  final reserveStatusColor;
  final historySlotName;
  final historyBuildingName;
  final historyStartTime;
  final historyEndTime;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    final specificReserveStatusColor =
        ReserveStatusSpecification().getReserveStatusColor(reserveStatusColor);

    var size = MediaQuery.of(context).size;
    final double widthSizedResponse = size.width > 500 ? 500 : double.infinity;

    // Split date time for right alignment.
    String alignDate(String date) {
      List<String> dateSplit = date.split("-");
      return "${dateSplit[2]}-${dateSplit[1]}-${dateSplit[0]}" ?? "";
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: widthSizedResponse,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: themeChange.darkTheme ? darkBar : lightBar,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularStatus(
                  specificReserveStatusColor: specificReserveStatusColor,
                ),
                historyEndTime != null
                    ? ReserveSection2(
                        slotName: historySlotName,
                        endTime: alignDate(historyEndTime))
                    : SizedBox(),
                ReserveSection1(
                    buildingName: historyBuildingName,
                    startTime: alignDate(historyStartTime)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReserveSection1 extends StatelessWidget {
  const ReserveSection1({
    this.buildingName,
    this.startTime,
  });

  final buildingName;
  final startTime;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        textDirection: TextDirection.ltr,
        children: [
          Text(
            "ساختمان : $buildingName",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 15,
            ),
          ),
          Text(
            "از : $startTime",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class ReserveSection2 extends StatelessWidget {
  const ReserveSection2({
    this.slotName,
    this.endTime,
  });

  final slotName;
  final endTime;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        textDirection: TextDirection.ltr,
        children: [
          Text(
            "جایگاه : $slotName",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 15,
            ),
          ),
          Text(
            "تا : $endTime",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class CircularStatus extends StatelessWidget {
  const CircularStatus({
    this.specificReserveStatusColor,
  });

  final specificReserveStatusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: specificReserveStatusColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
