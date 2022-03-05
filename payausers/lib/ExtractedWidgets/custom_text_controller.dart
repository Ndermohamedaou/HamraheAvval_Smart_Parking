import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class CustomTextController extends StatelessWidget {
  const CustomTextController(
      {this.text, this.fontSize, this.textColor, this.textAlign});

  final String text;
  final double fontSize;
  final textColor;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        fontFamily: mainFaFontFamily,
        color: textColor,
      ),
    ));
  }
}
