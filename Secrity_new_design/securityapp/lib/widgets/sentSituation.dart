import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

class SentSituation extends StatelessWidget {
  const SentSituation({
    this.send,
    this.text,
    this.icon,
    this.color,
    this.textColor,
    this.iconColor,
    this.isLoadingTime,
  });

  final Function send;
  final text;
  final icon;
  final color;
  final textColor;
  final iconColor;
  final isLoadingTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(2.0.w),
          color: color,
          child: MaterialButton(
              onPressed: send,
              minWidth: 40.0.w,
              height: 6.56.h,
              child: Row(
                children: [
                  isLoadingTime
                      ? Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: mainSectionCTA,
                            strokeWidth: 5,
                          ),
                        )
                      : CustomText(
                          text: text,
                          color: textColor,
                          size: 13.0.sp,
                        ),
                  SizedBox(width: 5.0.w),
                  Icon(
                    icon,
                    color: iconColor,
                  )
                ],
              )),
        ),
      ],
    );
  }
}
