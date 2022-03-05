import 'package:flutter/material.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/convert_date_to_string.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class StaticReserveInDetails extends StatelessWidget {
  const StaticReserveInDetails({
    this.cancelDays,
  });

  final List cancelDays;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    Map alignDate(String date) {
      /// Split date time for right alignment.
      try {
        ConvertDate convertDate = ConvertDate();
        // Split DateTime.
        List<String> dateSplit = date.split("-");
        // convertDate.convertDateToString(date)} -
        Jalali jalali = Jalali(int.parse(dateSplit[0]), int.parse(dateSplit[1]),
            int.parse(dateSplit[2]));

        String dayName = jalali.formatter.wN;
        String dayDate =
            "${dateSplit[0]}/${dateSplit[1]}/${dateSplit[2]}" ?? "";

        return {
          "dayName": dayName,
          "dayDate": dayDate,
        };
      } catch (e) {
        return {
          "dayName": "نامشخص",
          "dayDate": "نامشخص",
        };
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
        SizedBox(height: 1.0.h),
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
        /*
        alignDate(cancelDays[index])
         */
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: cancelDays.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTitle(
                      textTitle: alignDate(cancelDays[index])["dayName"],
                      fw: FontWeight.normal),
                  CustomSubTitle(
                    textTitle: alignDate(cancelDays[index])["dayDate"],
                  ),
                ],
              );
            },
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
