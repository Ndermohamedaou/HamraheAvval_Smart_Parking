import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
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
        margin: EdgeInsets.only(bottom: 20),
        child: Icon(Icons.inbox, size: 80.0),
      ),
      Text(
        serverConnectionProblem,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: mainFaFontFamily, fontSize: 18, color: Colors.red),
      ),
    ],
  );

  Widget waitCircularProgress() => const Center(
        child: CupertinoActivityIndicator(),
      );

  Widget loading() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            alignment: Alignment.center,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [mainSectionCTA],
            ),
          ),
        ],
      );
}
