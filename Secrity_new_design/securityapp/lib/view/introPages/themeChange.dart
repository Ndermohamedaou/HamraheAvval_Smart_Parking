import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({
    this.lightThemePressed,
    this.darkThemePressed,
  });

  final lightThemePressed;
  final darkThemePressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.42.h),
          CustomText(
            text: secondWelcome,
            size: 16.0.sp,
            align: TextAlign.center,
            fw: FontWeight.bold,
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0.h),
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FlatButton(
                  onPressed: lightThemePressed,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/lightTheme.png",
                        width: 55.0.w,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text: lightTheme,
                        size: 14.0.sp,
                        fw: FontWeight.bold,
                      )
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: darkThemePressed,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/darkTheme.png",
                        width: 55.0.w,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        text: darkTheme,
                        size: 14.0.sp,
                        fw: FontWeight.bold,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
