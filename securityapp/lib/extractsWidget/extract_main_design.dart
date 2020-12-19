import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class service_card extends StatelessWidget {
  service_card(
      {@required this.colour,
      @required this.margin,
      @required this.borderRadius,
      @required this.cardChild});

  final Color colour;
  final double margin;
  final double borderRadius;
  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: colour,
      ),
      child: cardChild,
    );
  }
}

class ColContentClass extends StatelessWidget {
  ColContentClass(
      {@required this.icon,
      @required this.iconSize,
      @required this.iconColor,
      @required this.textTitle,
      @required this.textDesc,
      @required this.fontFamily,
      @required this.fontSizeTitle,
      @required this.fontSizeDesc,
      @required this.textTitleColor,
      @required this.textDescColor});

  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String textTitle;
  final String textDesc;
  final String fontFamily;
  final double fontSizeTitle;
  final double fontSizeDesc;
  final Color textTitleColor;
  final Color textDescColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
        Text(
          textTitle,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSizeTitle,
            color: textTitleColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          textDesc,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSizeDesc,
            color: textDescColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
