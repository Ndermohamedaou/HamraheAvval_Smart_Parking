import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    this.qrCodeString,
    this.fullname,
    this.persCode,
    this.lastVisit,
  });

  final String qrCodeString;
  final String fullname;
  final String persCode;
  final lastVisit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95.0.w,
      height: 35.0.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [mainCTA, mainSectionCTA]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.0.w, bottom: 2.0.h),
                width: 40.0.w,
                height: 7.0.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(4.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/cardLogo.png",
                        width: 10.0.w,
                        height: 10.0.w,
                      ),
                    ),
                    SizedBox(width: 4.0.w),
                    Text(
                      "پارکینگ من",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: mainCardColor,
                          fontSize: 12.0.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // QRCode Section
                Container(
                  alignment: Alignment.center,
                  width: 12.0.h,
                  height: 12.0.h,
                  decoration: BoxDecoration(
                      color: HexColor("#EBEAFA"),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: QrImage(
                    data: qrCodeString,
                    version: QrVersions.auto,
                    padding: EdgeInsets.all(10),
                    foregroundColor: HexColor("#000000"),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        fullname.length > 15
                            ? "${fullname.substring(0, 15)}..."
                            : fullname,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: mainCardColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0.sp,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        persCode,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: persCodeColor,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        "اخرین \n ورود",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: lastVisitColor,
                          fontSize: 12.0.sp,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        lastVisit,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: Colors.black,
                          fontSize: 14.0.sp,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
