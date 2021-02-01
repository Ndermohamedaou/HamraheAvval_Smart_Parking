import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
          // Directionality(
          //   textDirection: TextDirection.rtl,
          //   child: Flushbar(
          //     title: "This is title",
          //     message: "This is super simple snakbar",
          //     flushbarPosition: FlushbarPosition.TOP,
          //     duration: Duration(seconds: 4),
          //     isDismissible: true,
          //     borderRadius: 8,
          //   ),
          // ),
          SizedBox(height: 40),
          Text(
            chooseDate,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
            ),
          ),
          SizedBox(height: 40),
          Lottie.asset("assets/lottie/datePick.json", width: double.infinity),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              onPressed: pressedDate,
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(HexColor("#6f03fc"))),
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
