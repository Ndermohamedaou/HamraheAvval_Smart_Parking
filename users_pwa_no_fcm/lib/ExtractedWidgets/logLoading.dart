import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          child: Icon(
            Icons.signal_cellular_connected_no_internet_0_bar_outlined,
            size: 35,
          )),
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
