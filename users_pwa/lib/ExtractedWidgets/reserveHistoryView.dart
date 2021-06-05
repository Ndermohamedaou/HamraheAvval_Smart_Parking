import 'package:flutter/material.dart';
import 'package:payausers/Model/ReserveColorsStatus.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class ReserveHistoryView extends StatelessWidget {
  const ReserveHistoryView(
      {this.reserveStatusColor,
      this.historyBuildingName,
      this.historySlotName,
      this.historyStartTime,
      this.historyEndTime});

  final reserveStatusColor;
  final historySlotName;
  final historyBuildingName;
  final historyStartTime;
  final historyEndTime;

  @override
  Widget build(BuildContext context) {
    final specificReserveStatusColor =
        ReserveStatusSpecification().getReserveStatusColor(reserveStatusColor);

    var size = MediaQuery.of(context).size;
    final double widthSizedResponse = size.width > 500 ? 500 : double.infinity;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: widthSizedResponse,
      height: 70.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage("assets/images/back.jpg"),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.25), BlendMode.srcOver),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: darkBar.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularStatus(
              specificReserveStatusColor: specificReserveStatusColor,
            ),
            ReserveSection2(slotName: historySlotName, endTime: historyEndTime),
            ReserveSection1(
                buildingName: historyBuildingName, startTime: historyStartTime),
          ],
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
              color: Colors.white,
            ),
          ),
          Text(
            "از : $startTime",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 15,
              color: Colors.white,
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
              color: Colors.white,
            ),
          ),
          Text(
            "تا : $endTime",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 15,
              color: Colors.white,
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
