import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    this.textTitle,
    this.fw,
  });
  final textTitle;
  final fw;
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
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: mainFaFontFamily, fontSize: 20.0, fontWeight: fw),
          ),
        ],
      ),
    );
  }
}
