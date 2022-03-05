import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class CustomMaterialButtonController extends StatelessWidget {
  const CustomMaterialButtonController(
      {this.buttonText,
      this.width = 120.0,
      this.buttonTextColor,
      this.buttonColor,
      this.onClick});

  final String buttonText;
  final buttonTextColor;
  final buttonColor;
  final Function onClick;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      width: width,
      // height: 60.0,
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(8.0),
        color: buttonColor,
        child: MaterialButton(
            onPressed: onClick,
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: buttonTextColor,
                  fontFamily: mainFaFontFamily,
                  fontSize: btnSized,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
