import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:time_range/time_range.dart';

// Show which date clicked and prepare to send it to API
String datePickedByUser = "";
String startTime = "";
String endTime = "";

class ReservedTab extends StatefulWidget {
  @override
  _ReservedTabState createState() => _ReservedTabState();
}

class _ReservedTabState extends State<ReservedTab> {
  // our text controller
  final TextEditingController textEditingController = TextEditingController();

  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: "${DateTime.now()}",
      fontFamily: mainFaFontFamily,
      onChange: (String oldDate, String newDate) {
        setState(() {
          datePickedByUser = newDate;
          print(datePickedByUser);
        });
      },
    ).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(startTime);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_rounded),
                    ),
                    Container(
                      child: Text(
                        choseReserveDate,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: subTitleSize),
                      ),
                    ),
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return persianDatePicker;
                        });
                  },
                  child: Icon(Icons.calendar_today_rounded)),
              Text(
                datePickedByUser,
                style: TextStyle(
                    fontFamily: mainFaFontFamily, fontSize: subTitleSize),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Text(
                      choseTime,
                      style: TextStyle(
                          fontFamily: mainFaFontFamily, fontSize: subTitleSize),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TimeRange(
                      fromTitle: Text(
                        'از',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: mainFaFontFamily),
                      ),
                      toTitle: Text(
                        'تا',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: mainFaFontFamily),
                      ),
                      titlePadding: 20,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: mainFaFontFamily),
                      activeTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: mainFaFontFamily),
                      borderColor: Colors.blue[500],
                      backgroundColor: Colors.transparent,
                      activeBackgroundColor: Colors.blue,
                      firstTime: TimeOfDay(hour: 00, minute: 00),
                      lastTime: TimeOfDay(hour: 23, minute: 00),
                      timeStep: 60,
                      timeBlock: 60,
                      onRangeCompleted: (range) {
                        setState(() {
                          startTime = range.start.format(context);
                          endTime = range.end.format(context);
                        });
                      }),
                ),
              ),
              Text(
                "$startTime - $endTime",
                style: TextStyle(
                    fontFamily: mainFaFontFamily, fontSize: subTitleSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
