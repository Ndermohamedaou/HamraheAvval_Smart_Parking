import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class CustomSubTitle extends StatelessWidget {
  const CustomSubTitle({this.textTitle, this.color});
  final textTitle;
  final color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              color: color,
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
