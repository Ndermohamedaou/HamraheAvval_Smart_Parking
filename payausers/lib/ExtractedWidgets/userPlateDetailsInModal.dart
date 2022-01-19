import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ExtractedWidgets/custom_divider.dart';
import 'package:payausers/ExtractedWidgets/custom_sub_title.dart';
import 'package:payausers/ExtractedWidgets/custom_title.dart';
import 'package:payausers/Model/PlateColorsStatus.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class UserPlateInDetails extends StatelessWidget {
  const UserPlateInDetails(
      {Key key,
      @required this.themeChange,
      this.plate,
      this.hrStatus,
      this.secStatus,
      this.overalStatus,
      this.delUserPlate})
      : super(key: key);

  final DarkThemeProvider themeChange;
  final List plate;
  final hrStatus;
  final secStatus;
  final overalStatus;
  final Function delUserPlate;

  @override
  Widget build(BuildContext context) {
    final hrStatusFinal =
        PlateStatusSpecification().getPlateStatusString(hrStatus);
    final hrStatusColorFinal =
        PlateStatusSpecification().getPlateStatusColor(hrStatus);

    final secStatusFinal =
        PlateStatusSpecification().getPlateStatusString(secStatus);
    final secStatusColorFinal =
        PlateStatusSpecification().getPlateStatusColor(secStatus);

    final overalStatusFinal =
        PlateStatusSpecification().getPlateStatusString(overalStatus);
    final overalStatusColorFinal =
        PlateStatusSpecification().getPlateStatusColor(overalStatus);

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
        SizedBox(height: 2.0.h),
        CustomTitle(textTitle: "پلاک شما در سامانه", fw: FontWeight.normal),
        PlateViewer(
          plate0: plate[0],
          plate1: plate[1],
          plate2: plate[2],
          plate3: plate[3],
          themeChange: themeChange.darkTheme,
        ),
        SizedBox(height: 2.0.h),
        DottedLine(dashColor: Colors.grey),
        SizedBox(height: 2.0.h),
        CustomTitle(
            textTitle: "وضعیت جاری پلاک شما در سامانه", fw: FontWeight.normal),
        SizedBox(height: 1.0.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: insideSectionText, fw: FontWeight.normal),
            CustomSubTitle(textTitle: hrStatusFinal, color: hrStatusColorFinal),
          ],
        ),
        CustomDivider(),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: securitySectionText, fw: FontWeight.normal),
            CustomSubTitle(
                textTitle: secStatusFinal, color: secStatusColorFinal),
          ],
        ),
        CustomDivider(),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(textTitle: "وضعیت کلی پلاک", fw: FontWeight.normal),
            CustomSubTitle(
                textTitle: overalStatusFinal, color: overalStatusColorFinal),
          ],
        ),
        SizedBox(height: 2.0.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.red,
            child: MaterialButton(
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () => delUserPlate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      "حذف پلاک",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: loginBtnTxtColor,
                          fontFamily: mainFaFontFamily,
                          fontSize: 18.0,
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
