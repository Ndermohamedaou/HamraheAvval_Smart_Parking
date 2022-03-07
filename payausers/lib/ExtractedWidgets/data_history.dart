import 'package:flutter/material.dart';
import 'package:payausers/Model/reserve_colors_status.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/controller/convert_date_to_string.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:provider/provider.dart';

class DataHistory extends StatelessWidget {
  const DataHistory({
    this.reserveStatusColor,
    this.historyBuildingName,
    this.historySlotName,
    this.historyStartTime,
    this.historyEndTime,
    this.onPressed,
    this.reserveType,
    this.datePrefix = "",
  });

  final reserveStatusColor;
  final historySlotName;
  final historyBuildingName;
  final historyStartTime;
  final historyEndTime;
  final String reserveType;
  final Function onPressed;
  final String datePrefix;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    AppLocalizations t = AppLocalizations.of(context);

    final specificReserveStatusColor = ReserveStatusSpecification(context)
        .getReserveStatusColor(reserveStatusColor);

    var size = MediaQuery.of(context).size;
    final double widthSizedResponse = size.width > 500 ? 500 : double.infinity;

    final dateOfHistory = t.translate(
        datePrefix == "weekly" ? "startWeek" : "income.entranceDateReserve");

    String alignDate(String date) {
      /// Split date time for right alignment.
      try {
        ConvertDate convertDate = ConvertDate();
        // Split DateTime.
        List<String> dateSplit = date.split(" ");
        List<String> dateString = dateSplit[0].split("-");
        convertDate.convertDateToString(dateSplit[0]);

        String dateTimeWeekText = datePrefix == "weekly"
            ? "${dateString[0]}/${dateString[1]}/${dateString[2]}"
            : "${convertDate.convertDateToString(dateSplit[0])} - ${dateString[0]}/${dateString[1]}/${dateString[2]}";

        return dateTimeWeekText ?? "";
      } catch (e) {
        // print(e);
        return t.translate("dateCatch");
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
              reserveStatusColor == null
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text("$dateOfHistory: ${alignDate(historyStartTime)}",
                              style: TextStyle(
                                  fontSize: 15, fontFamily: mainFaFontFamily)),
                          CircularStatus(
                            specificReserveStatusColor:
                                specificReserveStatusColor,
                          ),
                        ],
                      ),
                    ),

              reserveStatusColor != null
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.only(top: 8),
                      child: RowItem(
                          title: t.translate("income.entranceDateReserve"),
                          value: alignDate(historyStartTime)),
                    ),

              // End time for exit time traffic in traffic tab view.
              // When we use this widget in reserve view we will see
              // Circle indicator on this widget else when we use that in
              // traffic tab view we must not see indicator, we only see exit
              // DateTime of user traffic in parking.
              historyEndTime == "" && reserveStatusColor != null
                  ? SizedBox()
                  : Divider(
                      color: Colors.grey,
                      thickness: 0.25,
                      indent: 0,
                    ),

              historyEndTime == "" && reserveStatusColor != null
                  ? SizedBox()
                  : RowItem(
                      title: t.translate("outcome.exitDateReserve"),
                      value: alignDate(historyEndTime)),

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
                      title: t.translate("reserves.reserveType"),
                      value: reserveType,
                    ),
              // Building section.
              Divider(
                color: Colors.grey,
                thickness: 0.25,
                indent: 0,
              ),
              RowItem(
                title: t.translate("buildingName"),
                value: historyBuildingName,
              ),
              // Slot section.
              Divider(
                color: Colors.grey,
                thickness: 0.25,
                indent: 0,
              ),
              RowItem(
                title: t.translate("slotNameText"),
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
