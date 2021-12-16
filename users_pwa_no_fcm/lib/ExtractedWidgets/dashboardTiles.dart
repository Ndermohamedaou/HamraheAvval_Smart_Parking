import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:sizer/sizer.dart';

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
    var size = MediaQuery.of(context).size;
    final double mainFont = size.width > 900 ? 8.0.sp : 12.0.sp;
    final double subFont = size.width > 900 ? 6.0.sp : 10.0.sp;
    final double iconSize = size.width > 900 ? 3.0.w : 4.0.w;
    final double circleIconSize = size.width > 900 ? 4.0.w : 8.0.w;

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
                child: Icon(icon, size: iconSize, color: iconColor),
                width: circleIconSize,
                height: circleIconSize,
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
                      mainText: text, fontColor: Colors.white, size: mainFont),
                  TextPos(
                    mainText: subText,
                    fontColor: Colors.white,
                    size: mainFont,
                  ),
                  TextPos(
                    mainText: subSubText,
                    fontColor: subSubTextColor,
                    size: subFont,
                  ),
                ]),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lenOfStuff != null ? lenOfStuff : "",
                style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    color: Colors.white,
                    fontSize: 15),
              ),
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
