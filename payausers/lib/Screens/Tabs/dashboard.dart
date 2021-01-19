import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/userLeading.dart';

class Dashboard extends StatelessWidget {
  const Dashboard(
      {this.fullnameMeme, this.userPersonalCodeMeme, this.avatarMeme});
  final String fullnameMeme;
  final String userPersonalCodeMeme;
  final Widget avatarMeme;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          // User Summery details on dashboard screen
          Directionality(
            textDirection: TextDirection.rtl,
            child: UserLeading(
              fullname: fullnameMeme,
              userPersonalCode: userPersonalCodeMeme,
              avatarImg: avatarMeme,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 20),
                  width: 26,
                  height: 26,
                  child: Icon(Icons.trending_up_sharp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: bgColorTrendingUp),
                ),
                Text(
                  todayWeather,
                  style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainTitleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
