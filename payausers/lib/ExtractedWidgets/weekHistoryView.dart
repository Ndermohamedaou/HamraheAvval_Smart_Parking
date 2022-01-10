import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';

class WeekHistoryView extends StatelessWidget {
  const WeekHistoryView({
    this.startWeekDateString,
    this.onPressed,
  });

  final startWeekDateString;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var size = MediaQuery.of(context).size;
    final double widthSizedResponse = size.width > 500 ? 500 : double.infinity;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: widthSizedResponse,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: themeChange.darkTheme ? darkBar : lightBar,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Column(
                    textDirection: TextDirection.ltr,
                    children: [
                      Text(
                        "$startWeekDaysFrom $startWeekDateString",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
