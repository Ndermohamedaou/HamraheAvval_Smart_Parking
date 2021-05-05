import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
          SizedBox(height: 40),
          // Image.asset(
          //   "assets/images/calenderGif.gif",
          //   width: 30.0.w,
          // ),
          SizedBox(height: 40),
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
