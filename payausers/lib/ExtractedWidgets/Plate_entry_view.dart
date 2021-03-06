import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/plate_editor.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlateEntry extends StatelessWidget {
  const PlateEntry({
    this.plate0,
    this.plate0Adder,
    this.plate1,
    this.plate1Adder,
    this.value,
    this.plate2,
    this.plate2Adder,
    this.plate3,
    this.plate3Adder,
  });

  final plate0;
  final Function plate0Adder;
  final plate1;
  final Function plate1Adder;
  final int value;
  final plate2;
  final Function plate2Adder;
  final plate3;
  final Function plate3Adder;

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: themeChange.darkTheme ? darkBar : lightBar,
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.centerRight,
              child: Text(
                t.translate("plates.addPlate.enterPlateNote"),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 10.0.w, bottom: 10.0.w, right: 10.0.w, left: 10.0.w),
              padding: EdgeInsets.all(10.0),
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                color: themeChange.darkTheme ? darkBar : lightBar,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.asset(
                "assets/images/myTraffic.png",
                width: 40.0.w,
              ),
            ),
            PlateEditor(
              plate0: plate0,
              plate0Adder: plate0Adder,
              plate1: plate1,
              plate1Adder: plate1Adder,
              plate2: plate2,
              plate2Adder: plate2Adder,
              plate3: plate3,
              plate3Adder: plate3Adder,
            ),
          ],
        ),
      ),
    );
  }
}
