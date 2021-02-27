import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

class CapturingOption extends StatelessWidget {
  const CapturingOption({
    this.capture,
    this.text,
    this.icon,
  });

  final Function capture;
  final text;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(2.0.w),
          color: mainCTA,
          child: MaterialButton(
              onPressed: capture,
              minWidth: 40.0.w,
              height: 6.56.h,
              child: Row(
                children: [
                  CustomText(
                    text: text,
                    color: Colors.white,
                    size: 13.0.sp,
                  ),
                  SizedBox(width: 5.0.w),
                  Icon(
                    icon,
                    color: Colors.white,
                  )
                ],
              )),
        ),
      ],
    );
  }
}
