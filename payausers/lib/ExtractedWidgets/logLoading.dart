import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class LogLoading {
  Widget notFoundReservedData({String msg}) => Column(
        children: [
          Image.asset(
            "assets/images/emptyBox.png",
            width: 180,
            height: 180,
          ),
          Text("شما $msg انجام نداده اید",
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
        ],
      );
  Widget internetProblem = Column(
    children: [
      Lottie.asset(
        "assets/lottie/notFoundTraffics.json",
        width: 180,
        height: 180,
      ),
      Text("عدم برقراری ارتباط با سرویس دهنده",
          style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
    ],
  );
}
