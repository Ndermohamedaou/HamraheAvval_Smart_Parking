import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/Model/ReserveColorsStatus.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';

class ReserveHistoryView extends StatelessWidget {
  const ReserveHistoryView(
      {this.reserveStatusColor,
      this.historyBuildingName,
      this.historySlotName,
      this.historyStartTime,
      this.historyEndTime,
      this.onPressed,
      this.reserveType});

  final reserveStatusColor;
  final historySlotName;
  final historyBuildingName;
  final historyStartTime;
  final historyEndTime;
  final String reserveType;
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
      try {
        return "${dateSplit[0]}/${dateSplit[1]}/${dateSplit[2]}" ?? "";
      } catch (e) {
        return "";
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: widthSizedResponse,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: themeChange.darkTheme
                  ? Colors.grey.shade900
                  : Colors.grey.shade300,
              spreadRadius: 3,
              blurRadius: 20.0),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: themeChange.darkTheme ? darkBar : lightBar,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: onPressed,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text("$dateOfReserve: ${alignDate(historyStartTime)}",
                        style: TextStyle(
                            fontSize: 15, fontFamily: mainFaFontFamily)),
                    CircularStatus(
                      specificReserveStatusColor: specificReserveStatusColor,
                    ),
                  ],
                ),
              ),
              // Reserve type
              reserveType == null
                  ? SizedBox()
                  : Divider(
                      color: Colors.grey,
                      thickness: 0.25,
                      indent: 0,
                    ),
              reserveType == null
                  ? SizedBox()
                  : RowItem(
                      title: reserveTypeText,
                      value: reserveType,
                    ),
              // Building section.
              Divider(
                color: Colors.grey,
                thickness: 0.25,
                indent: 0,
              ),
              RowItem(
                title: buildingNameText,
                value: historyBuildingName,
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.25,
                indent: 0,
              ),
              RowItem(
                title: slotNameText,
                value: historySlotName,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  const RowItem({Key key, this.title, this.value}) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: mainFaFontFamily,
                  fontWeight: FontWeight.w100)),
          Text(value,
              style: TextStyle(fontSize: 15, fontFamily: mainFaFontFamily)),
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
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: specificReserveStatusColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
