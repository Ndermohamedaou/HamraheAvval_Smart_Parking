import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PlateViewer extends StatelessWidget {
  const PlateViewer(
      {this.plate0, this.plate1, this.plate2, this.plate3, this.themeChange});

  final plate0;
  final plate1;
  final plate2;
  final plate3;
  final bool themeChange;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 70,
        // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(
                color: themeChange ? Colors.white : Colors.black, width: 2.8),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 2),
                  Image.asset(
                    "assets/images/iranFlag.png",
                    width: 35,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I.R.',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'I R A N',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 70,
              margin: EdgeInsets.only(top: 12),
              child: Text(
                plate0,
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: mainFaFontFamily,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 60,
              height: 70,
              margin: EdgeInsets.only(top: 12),
              child: Text(
                plate1,
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: mainFaFontFamily,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 50,
              height: 70,
              margin: EdgeInsets.only(top: 12, right: 0),
              child: Text(
                plate2,
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: mainFaFontFamily,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            VerticalDivider(
                width: 1,
                color: themeChange ? Colors.white : Colors.black,
                thickness: 3),
            Container(
              width: 50,
              height: 70,
              margin: EdgeInsets.only(top: 12, left: 10),
              child: Text(
                plate3,
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: mainFaFontFamily,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
        ));
  }
}
