import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

class SearchBtn extends StatelessWidget {
  const SearchBtn({
    this.searchPressed,
  });

  final Function searchPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.circular(2.0.w),
          color: mainCTA,
          child: MaterialButton(
            onPressed: searchPressed,
            minWidth: 40.0.w,
            height: 6.56.h,
            child: CustomText(
              text: searchBtnText,
              color: Colors.white,
              size: 13.0.sp,
            ),
          ),
        ),
      ],
    );
  }
}
