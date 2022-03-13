import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

Map source;

class ImgProcessingResult extends StatefulWidget {
  @override
  _ImgProcessingResultState createState() => _ImgProcessingResultState();
}

class _ImgProcessingResultState extends State<ImgProcessingResult> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    source = ModalRoute.of(context).settings.arguments;
    // TODO: Change my bad.
    // Getting result Map
    Map result = source['res'];
    // Getting Image from Locally
    String img = source['img'];
    // source["status"] is status of submission
    String statusOfSent = source["status"] != null ? source["status"] : "";
    String processTitle = statusOfSent == "0"
        ? "ثبت ورود"
        : statusOfSent == "1"
            ? "ثبت خروج"
            : "";
    // Preparing slot number with result Map
    String slotNum =
        result["slot"] != null ? result["slot"] : "خطار در دریافت شماره جایگاه";

    final status = result['status'] == 1200 || result['status'] == 200
        ? submissionMsg
        : result['status'] == 150
            ? badImgEquality
            : result['status'] == 1100
                ? notFoundInfoForThis
                : result['status'] == 550
                    ? failedResponse
                    : result['status'] == 350
                        ? notEmptyMsg
                        : result['status'] == 100
                            ? recentlyUsedMsg
                            : "خطا در دریافت و محاسبه وضعیت ارسال و ثبت";

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "نتیجه پردازش در $processTitle",
        ),
        centerTitle: true,
        backgroundColor: mainCTA,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset("assets/animation/submiting.json",
                repeat: false, width: 100.0.w, height: 30.0.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  CustomText(
                    text: status,
                    size: 14.0.sp,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  CustomText(
                    text: "شماره جایگاه : $slotNum",
                    size: 14.0.sp,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: img != ""
                  ? Image.memory(
                      base64.decode(img),
                      width: 100.0.w,
                      height: 70.0.h,
                    )
                  : CustomText(
                      text: "تصویری یافت نشد",
                    ),
            ),
            SizedBox(height: 5.0.h),
            Material(
              borderRadius: BorderRadius.circular(2.0.w),
              color: mainCTA,
              child: MaterialButton(
                onPressed: () => Navigator.popUntil(
                    context, ModalRoute.withName(mainoRoute)),
                minWidth: 40.0.w,
                height: 6.56.h,
                child: CustomText(
                  text: "تایید و بازگشت",
                  color: Colors.white,
                  align: TextAlign.center,
                  size: 13.0.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlateView extends StatelessWidget {
  const PlateView({
    Key key,
    this.plate0,
    this.plate1,
    this.plate2,
    this.plate3,
    @required this.themeChange,
  }) : super(key: key);

  final DarkThemeProvider themeChange;
  final plate0;
  final plate1;
  final plate2;
  final plate3;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0.w,
      height: 70,
      margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
              width: 2.8),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 2),
                Image.asset(
                  "assets/images/iranFlag.png",
                  width: 35,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I.R.',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'I R A N',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 13.0.w,
            height: 70,
            margin: EdgeInsets.only(top: 5),
            child: TextFormField(
              readOnly: true,
              style: TextStyle(
                  letterSpacing: 5,
                  fontSize: 25.0.sp,
                  fontFamily: mainFont,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              initialValue: plate0,
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              maxLength: 2,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            width: 13.0.w,
            height: 70,
            margin: EdgeInsets.only(top: 5),
            child: TextFormField(
              readOnly: true,
              style: TextStyle(
                  letterSpacing: 5,
                  fontSize: 25.0.sp,
                  fontFamily: mainFont,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              initialValue: plate1,
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              maxLength: 2,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            width: 20.0.w,
            height: 70,
            margin: EdgeInsets.only(top: 5),
            child: TextFormField(
              readOnly: true,
              initialValue: plate2,
              style: TextStyle(
                  letterSpacing: 5,
                  fontSize: 25.0.sp,
                  fontFamily: mainFont,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              maxLength: 3,
              keyboardType: TextInputType.number,
            ),
          ),
          VerticalDivider(
              width: 1,
              color: themeChange.darkTheme ? Colors.white : Colors.black,
              thickness: 3),
          Container(
            width: 14.0.w,
            height: 70,
            margin: EdgeInsets.only(top: 5, right: 10),
            child: TextFormField(
              readOnly: true,
              initialValue: plate3,
              style: TextStyle(
                  letterSpacing: 5,
                  fontSize: 25.0.sp,
                  fontFamily: mainFont,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              maxLength: 2,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }
}
