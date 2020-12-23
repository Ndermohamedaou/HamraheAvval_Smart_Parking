import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'package:securityapp/constFile/texts.dart';

class BuildingsCustomText extends StatelessWidget {
  BuildingsCustomText({@required this.text, this.textColor});

  final String text;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: textColor,
          fontFamily: mainFontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 20),
    );
  }
}

class DropdownIcon extends StatelessWidget {
  const DropdownIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          CupertinoIcons.building_2_fill,
          color: Colors.blue[500],
          textDirection: TextDirection.rtl,
        ));
  }
}
