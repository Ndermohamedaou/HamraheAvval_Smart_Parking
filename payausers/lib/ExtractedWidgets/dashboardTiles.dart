import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class DashboardTiles extends StatelessWidget {
  const DashboardTiles(
      {this.tileColor,
      this.text,
      this.subSubText,
      this.subSubTextColor,
      this.subText,
      this.icon,
      this.iconColor,
      this.lenOfStuff});

  final tileColor;
  final String text;
  final String subText;
  final String subSubText;
  final Color subSubTextColor;
  final IconData icon;
  final Color iconColor;
  final String lenOfStuff;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        // color: HexColor(tileColor),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          stops: [0.1, 0.9],
          colors: tileColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Icon(icon, size: 33, color: iconColor),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextPos(
                      mainText: text,
                      fontColor: Colors.white,
                      size: mainFontSize),
                  TextPos(
                    mainText: subText,
                    fontColor: Colors.white,
                    size: mainFontSize,
                  ),
                  TextPos(
                    mainText: subSubText,
                    fontColor: subSubTextColor,
                    size: subFontSize,
                  ),
                ]),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomLeft,
            child: Text(
              lenOfStuff != null ? lenOfStuff : "",
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  color: Colors.white,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class TextPos extends StatelessWidget {
  const TextPos({this.mainText, this.fontColor, this.size});

  final String mainText;
  final Color fontColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          mainText,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            color: fontColor,
            fontSize: size,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
