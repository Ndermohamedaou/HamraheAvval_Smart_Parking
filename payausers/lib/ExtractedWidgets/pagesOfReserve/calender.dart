import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class DateUserPicker extends StatelessWidget {
  const DateUserPicker({@required this.pressedDate, this.pickedDateText});

  final Function pressedDate;
  final String pickedDateText;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Lottie.asset("assets/lottie/datePick.json", width: 300),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              onPressed: pressedDate,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(mainCTA)),
              icon: Icon(Icons.calendar_today, size: 18),
              label: Text(
                openCalender,
                style: TextStyle(fontFamily: mainFaFontFamily),
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            pickedDateText,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
            ),
          ),
          SizedBox(height: 175),
        ],
      ),
    );
  }
}
