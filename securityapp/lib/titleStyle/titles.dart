import 'package:flutter/material.dart';

class AppBarTitleConfig extends StatelessWidget {
  AppBarTitleConfig(
      {@required this.titleText, @required this.textStyles, this.titleAlign});

  final String titleText;
  final TextStyle textStyles;
  final TextAlign titleAlign;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        titleText,
        style: textStyles,
        textAlign: titleAlign,
      ),
    );
  }
}
