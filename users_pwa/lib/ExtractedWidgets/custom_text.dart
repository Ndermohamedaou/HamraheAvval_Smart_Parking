import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    this.text,
    this.color,
    this.size,
    this.align = TextAlign.center,
    this.weight = FontWeight.normal,
  });

  final text;
  final color;
  final size;
  final align;
  final weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: mainFaFontFamily,
          fontWeight: weight),
    );
  }
}
