import 'package:flutter/material.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class ReserveInDetails extends StatelessWidget {
  const ReserveInDetails({
    Key key,
    @required this.themeChange,
    this.plate,
    this.startTime,
    this.endTime,
    this.building,
    this.slot,
    this.delReserve,
  }) : super(key: key);

  final DarkThemeProvider themeChange;
  final List plate;
  final startTime;
  final endTime;
  final building;
  final slot;
  final Function delReserve;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.0.h),
        CustomTitle(textTitle: "پلاک منتخب رزرو", fw: FontWeight.bold),
        PlateViewer(
          plate0: plate[0],
          plate1: plate[1],
          plate2: plate[2],
          plate3: plate[3],
          themeChange: themeChange.darkTheme,
        ),
        SizedBox(height: 2.0.h),
        CustomTitle(textTitle: "ساعت ورود", fw: FontWeight.bold),
        CustomSubTitle(textTitle: startTime),
        SizedBox(height: 2.0.h),
        CustomTitle(textTitle: "ساعت خروج", fw: FontWeight.bold),
        CustomSubTitle(textTitle: endTime),
        SizedBox(height: 2.0.h),
        CustomTitle(textTitle: "ساختمان", fw: FontWeight.bold),
        CustomSubTitle(textTitle: building),
        SizedBox(height: 2.0.h),
        CustomTitle(textTitle: "جایگاه", fw: FontWeight.bold),
        CustomSubTitle(textTitle: slot),
        SizedBox(height: 2.0.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.red,
            child: MaterialButton(
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () => delReserve(),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "لفو کردن رزرو",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: loginBtnTxtColor,
                          fontFamily: mainFaFontFamily,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    )
                  ],
                )),
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
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: mainFaFontFamily, fontSize: 20.0, fontWeight: fw),
          ),
        ],
      ),
    );
  }
}

class CustomSubTitle extends StatelessWidget {
  const CustomSubTitle({
    this.textTitle,
  });
  final textTitle;
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
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
