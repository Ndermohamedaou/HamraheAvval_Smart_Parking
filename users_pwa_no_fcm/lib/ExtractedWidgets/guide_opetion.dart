import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';

class Option extends StatelessWidget {
  const Option({
    @required this.themeChange,
    this.text,
  });

  final DarkThemeProvider themeChange;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: themeChange.darkTheme ? darkBar : lightBar,
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: 20.0,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
