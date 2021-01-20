import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class ReservedTab extends StatelessWidget {
  const ReservedTab({this.mainThemeColor});

  final mainThemeColor;

  @override
  Widget build(BuildContext context) {
    // Change Lottie Background with dark/light theme
    var notThere = mainThemeColor.darkTheme
        ? "assets/lottie/reserve_dark.json"
        : "assets/lottie/reserve_light.json";
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reserveTextTitle,
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: subTitleSize,
                          fontWeight: FontWeight.bold),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.blue, // button color
                        child: InkWell(
                          splashColor: Colors.blue[300], // inkwell color
                          child: SizedBox(
                              width: 46,
                              height: 46,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                          onTap: () =>
                              Navigator.pushNamed(context, "/addReserve"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Center(
                    child: Container(
                        margin: EdgeInsets.all(50),
                        width: 250,
                        height: 250,
                        child: Lottie.asset(notThere))),
                Text(choseTime,
                    style:
                        TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
