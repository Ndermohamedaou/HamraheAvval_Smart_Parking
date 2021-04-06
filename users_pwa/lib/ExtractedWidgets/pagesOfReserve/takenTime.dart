import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class TimerPicker extends StatelessWidget {
  const TimerPicker(
      {this.context,
      this.starterTimePressed,
      this.endTimePressed,
      this.startTimeText,
      this.endTimeText});
  final context;
  final Function starterTimePressed;
  final Function endTimePressed;
  final String startTimeText;
  final String endTimeText;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            child: Image.asset(
              "assets/images/clockGif.gif",
              width: 40.0.w,
            ),
          ),
          SizedBox(height: 30),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              onPressed: starterTimePressed,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(mainCTA)),
              icon: Icon(Icons.timer, size: 18),
              label: Text(
                entryTime,
                style: TextStyle(fontFamily: mainFaFontFamily),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            startTimeText,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
            ),
          ),
          SizedBox(height: 40),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              onPressed: endTimePressed,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(mainCTA)),
              icon: Icon(Icons.timer_off, size: 18),
              label: Text(
                exitTime,
                style: TextStyle(fontFamily: mainFaFontFamily),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            endTimeText,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
            ),
          ),
        ],
      ),
    );
  }
}