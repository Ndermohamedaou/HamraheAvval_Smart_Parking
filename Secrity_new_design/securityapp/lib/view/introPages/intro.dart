import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

class Intro extends StatelessWidget {
  const Intro({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.42.h),
            Center(
              child: Image.asset(
                "assets/images/iphoneModel.png",
                width: 50.0.w,
              ),
            ),
            SizedBox(height: 4.0.h),
            CustomText(
              text: firstWelcome,
              align: TextAlign.center,
              size: 16.0.sp,
              fw: FontWeight.bold,
            ),
            SizedBox(height: 4.42.h),
          ],
        ),
      ),
    );
  }
}
