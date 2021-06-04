import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class LogLoading {
  Widget notFoundReservedData({String msg}) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/emptyBox.png",
                width: 180,
                height: 180,
              ),
            ),
            Text(
              "شما $msg انجام نداده اید",
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
  Widget internetProblem = Column(
    children: [
      Container(
        alignment: Alignment.center,
        child: Lottie.asset(
          "assets/lottie/notFoundTraffics.json",
          width: 180,
          height: 180,
        ),
      ),
      Text(
        serverConnectionProblem,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18),
      ),
    ],
  );

  Widget waitCircularProgress() => const Center(
        child: CupertinoActivityIndicator(),
      );
}
