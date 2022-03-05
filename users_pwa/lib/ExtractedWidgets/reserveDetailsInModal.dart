import 'package:flutter/material.dart';
import 'package:payausers/Model/ReserveColorsStatus.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class ReserveInDetails extends StatelessWidget {
  const ReserveInDetails({
    Key key,
    @required this.themeChange,
    this.plate,
    this.startTime,
    this.reserveStatusDesc,
    this.endTime,
    this.building,
    this.slot,
    this.delReserve,
    this.reserveTimeExpire,
    this.isShowCancelReserve,
  }) : super(key: key);

  final DarkThemeProvider themeChange;
  final List plate;
  final startTime;
  final endTime;
  final building;
  final slot;
  final Function delReserve;
  final reserveStatusDesc;
  final int reserveTimeExpire;
  final bool isShowCancelReserve;

  @override
  Widget build(BuildContext context) {
    String nowTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
    int nowTime = int.parse(nowTimestamp.substring(0, 10));

    final specificReserveStatusColor =
        ReserveStatusSpecification().getReserveStatusColor(reserveStatusDesc);
    return Column(
      children: [
        SizedBox(height: 1.0.h),
        Container(
          width: 50,
          height: 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20)),
        ),
        plate.isEmpty
            ? SizedBox()
            : PlateViewer(
                plate0: plate[0],
                plate1: plate[1],
                plate2: plate[2],
                plate3: plate[3],
                themeChange: themeChange.darkTheme,
              ),
        // SizedBox(height: 2.0.h),
        // DottedLine(dashColor: Colors.grey),
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
            CustomTitle(textTitle: "زمان ورود", fw: FontWeight.normal),
            CustomSubTitle(textTitle: startTime),
          ],
        ),
        SizedBox(height: 2.0.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: "زمان خروج", fw: FontWeight.normal),
            CustomSubTitle(textTitle: endTime),
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
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: "جایگاه", fw: FontWeight.normal),
            CustomSubTitle(textTitle: slot),
          ],
        ),
        SizedBox(height: 2.0.h),
        // Check if reserve was canceled it doesn't show any button to cancel again.
        !isShowCancelReserve
            ? SizedBox()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.red,
                  child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () => delReserve(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            "لغو کردن رزرو",
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
