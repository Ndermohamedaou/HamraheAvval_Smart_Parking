import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class FloatingButtonController extends StatelessWidget {
  const FloatingButtonController({
    Key key,
    this.buttonText,
    this.onPressed,
    this.width,
    this.height,
    this.buttonColor,
    this.buttonIcon,
  }) : super(key: key);

  final String buttonText;
  final Function onPressed;
  final double width;
  final double height;
  final buttonColor;
  final IconData buttonIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(100.0),
        color: buttonColor,
        child: MaterialButton(
          onPressed: onPressed,
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                buttonText,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: mainFaFontFamily,
                    fontSize: btnSized,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(width: 1.0.w),
              Icon(buttonIcon, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
