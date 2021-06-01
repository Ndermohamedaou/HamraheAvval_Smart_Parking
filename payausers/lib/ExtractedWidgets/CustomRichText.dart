import 'package:flutter/material.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    Key key,
    this.textOne,
    this.textTwo,
    @required this.themeChange,
  }) : super(key: key);

  final DarkThemeProvider themeChange;
  final textOne;
  final textTwo;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: textOne,
          style: TextStyle(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
              fontFamily: mainFaFontFamily,
              fontSize: 19),
          children: [
            TextSpan(
                text: textTwo,
                style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    color: mainCTA,
                    fontWeight: FontWeight.bold,
                    fontSize: 19)),
          ]),
    );
  }
}
