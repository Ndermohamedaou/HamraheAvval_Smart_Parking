import 'package:flutter/material.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dropdownMenu.dart';
import 'package:provider/provider.dart';

class PlateEditor extends StatelessWidget {
  const PlateEditor({
    this.plate0,
    this.plate0Adder,
    this.plate1,
    this.plate1Adder,
    this.value,
    this.plate2,
    this.plate2Adder,
    this.plate3,
    this.plate3Adder,
  });

  final plate0;
  final Function plate0Adder;
  final plate1;
  final Function plate1Adder;
  final int value;
  final plate2;
  final Function plate2Adder;
  final plate3;
  final Function plate3Adder;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: double.infinity,
      height: 70,
      // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(
              color: themeChange.darkTheme ? Colors.white : Colors.black,
              width: 2.8),
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
            margin: EdgeInsets.only(top: 0),
            child: TextFormField(
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: mainFaFontFamily,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              initialValue: plate0,
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              maxLength: 2,
              keyboardType: TextInputType.number,
              onChanged: plate0Adder,
            ),
          ),
          Container(
            width: 60,
            height: 70,
            margin: EdgeInsets.only(top: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: plate1,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: mainFaFontFamily,
                    color: themeChange.darkTheme ? Colors.white : Colors.black,
                    fontSize: 22),
                items: dropdownMenu,
                onChanged: plate1Adder,
              ),
            ),
          ),
          Container(
            width: 50,
            height: 70,
            margin: EdgeInsets.only(top: 0, right: 0),
            child: TextFormField(
              initialValue: plate2,
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: mainFaFontFamily,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              maxLength: 3,
              keyboardType: TextInputType.number,
              onChanged: plate2Adder,
            ),
          ),
          VerticalDivider(
              width: 1,
              color: themeChange.darkTheme ? Colors.white : Colors.black,
              thickness: 3),
          Container(
            width: 50,
            height: 70,
            margin: EdgeInsets.only(top: 0, right: 10),
            child: TextFormField(
              initialValue: plate3,
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: mainFaFontFamily,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration:
                  InputDecoration(counterText: "", border: InputBorder.none),
              maxLength: 2,
              keyboardType: TextInputType.number,
              onChanged: plate3Adder,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }
}
