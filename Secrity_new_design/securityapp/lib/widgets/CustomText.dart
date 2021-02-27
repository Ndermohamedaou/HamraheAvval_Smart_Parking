import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initVar.dart';

class CustomText extends StatelessWidget {
  const CustomText({this.text, this.size, this.align, this.fw, this.color});

  final String text;
  final double size;
  final TextAlign align;
  final FontWeight fw;
  final color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: mainFont,
        fontSize: size,
        fontWeight: fw,
        color: color,
      ),
      textAlign: align != null ? align : TextAlign.right,
    );
  }
}
