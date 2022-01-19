import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class CustomClipOval extends StatelessWidget {
  const CustomClipOval(
      {this.aggreementPressed, this.icon, this.firstColor, this.secondColor});

  final aggreementPressed;
  final icon;
  final firstColor;
  final secondColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: firstColor, // button color
        child: InkWell(
          splashColor: secondColor, // inkwell color
          child: SizedBox(
              width: 46,
              height: 46,
              child: Icon(
                icon,
                color: Colors.white,
              )),
          onTap: aggreementPressed,
        ),
      ),
    );
  }
}
