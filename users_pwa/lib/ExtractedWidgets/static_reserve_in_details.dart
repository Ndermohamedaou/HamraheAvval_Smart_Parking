import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/Model/ReserveColorsStatus.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/convert_date_to_string.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class StaticReserveInDetails extends StatelessWidget {
  const StaticReserveInDetails({
    this.reserveStatusDesc = 1,
    this.building = "",
    this.slot = "",
    this.cancelDays,
    this.openCalendar,
  });

  final slot;
  final building;
  final Function openCalendar;
  final reserveStatusDesc;
  final List cancelDays;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final specificReserveStatusColor =
        ReserveStatusSpecification().getReserveStatusColor(reserveStatusDesc);

    String alignDate(String date) {
      /// Split date time for right alignment.

      try {
        ConvertDate convertDate = ConvertDate();
        // Split DateTime.
        List<String> dateSplit = date.split("/");
        // convertDate.convertDateToString(date)} -
        Jalali jalali = Jalali(int.parse(dateSplit[0]), int.parse(dateSplit[1]),
            int.parse(dateSplit[2]));

        return "${jalali.formatter.wN} - ${dateSplit[0]}/${dateSplit[1]}/${dateSplit[2]}" ??
            "";
      } catch (e) {
        return dateWasNull;
      }
    }

    return Column(
      children: [
        SizedBox(height: 1.0.h),
        Container(
          width: 30,
          height: 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        ),
        SizedBox(height: 2.0.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: "نتیجه رزرو", fw: FontWeight.normal),
            CustomSubTitle(
                textTitle: ReserveStatusSpecification()
                    .getReserveStatusString(reserveStatusDesc),
                color: specificReserveStatusColor),
          ],
        ),
        SizedBox(height: 2.0.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: "جایگاه", fw: FontWeight.normal),
            CustomSubTitle(textTitle: slot),
          ],
        ),
        SizedBox(height: 2.0.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: "ساختمان", fw: FontWeight.normal),
            CustomSubTitle(textTitle: building),
          ],
        ),
        SizedBox(height: 2.0.h),
        DottedLine(dashColor: Colors.grey),
        // Check if reserve was canceled you don't show any button to cancel again.
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(
                textTitle: "لیست روزهای لغو شده", fw: FontWeight.normal),
            CustomSubTitle(textTitle: ""),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: cancelDays.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                "${alignDate(cancelDays[index])}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: mainFaFontFamily,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.0.h),
        reserveStatusDesc == -2 || reserveStatusDesc == 2
            ? SizedBox()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.red,
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () => openCalendar(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          "لغو رزرو از هفته",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: loginBtnTxtColor,
                              fontFamily: mainFaFontFamily,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal),
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    this.textTitle,
    this.fw,
  });
  final textTitle;
  final fw;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: mainFaFontFamily, fontSize: 20.0, fontWeight: fw),
          ),
        ],
      ),
    );
  }
}

class CustomSubTitle extends StatelessWidget {
  const CustomSubTitle({this.textTitle, this.color});
  final textTitle;
  final color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: color,
              fontFamily: mainFaFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
