import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

class ThemeModeComponent extends StatelessWidget {
  const ThemeModeComponent(
      {@required this.lottieFile, this.onActive, this.color, this.title});

  final String lottieFile;
  final Function onActive;
  final String color;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onActive,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Lottie.asset(lottieFile),
            decoration: BoxDecoration(
                color: HexColor(color), borderRadius: BorderRadius.circular(0)),
          ),
        ],
      ),
    );
  }
}
