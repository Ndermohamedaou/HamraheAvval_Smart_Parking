import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class TimerPicker extends StatelessWidget {
  const TimerPicker({
    this.context,
    this.startTimeText,
    this.endTimeText,
    this.changeStartTime,
    this.changeEndTime,
  });
  final context;
  final int startTimeText;
  final int endTimeText;
  final Function changeStartTime;
  final Function changeEndTime;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 60),
          Container(
            child: Lottie.asset("assets/lottie/timePick.json", width: 150),
          ),
          SizedBox(height: 30),
          Text(
            "ساعت شروع",
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          HourPicker(hourTime: startTimeText, changedTime: changeStartTime),
          SizedBox(height: 30),
          Text(
            "ساعت پایان",
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          HourPicker(hourTime: endTimeText, changedTime: changeEndTime),
        ],
      ),
    );
  }
}

class HourPicker extends StatelessWidget {
  const HourPicker({
    Key key,
    this.hourTime,
    this.changedTime,
  }) : super(key: key);

  final int hourTime;
  final Function changedTime;

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      haptics: true,
      value: hourTime,
      minValue: 1,
      maxValue: 24,
      axis: Axis.horizontal,
      textStyle: TextStyle(
        fontFamily: mainFaFontFamily,
      ),
      selectedTextStyle: TextStyle(
        fontFamily: mainFaFontFamily,
        color: mainSectionCTA,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      onChanged: changedTime,
    );
  }
}
