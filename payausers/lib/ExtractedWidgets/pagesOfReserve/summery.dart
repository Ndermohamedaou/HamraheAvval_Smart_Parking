import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:sizer/sizer.dart';
import 'package:ticketview/ticketview.dart';

class Summery extends StatelessWidget {
  const Summery(
      {this.themeChange,
      this.isLoad,
      this.datePickedByUser,
      this.startTime,
      this.endTime,
      this.finalSelectedPlateToSending,
      this.sendToSubmit,
      this.pressedDate});

  final bool themeChange;
  final bool isLoad;
  final datePickedByUser;
  final startTime;
  final endTime;
  final finalSelectedPlateToSending;
  final Function sendToSubmit;
  final Function pressedDate;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final ticketSize = size.width > 400 ? 400.0 : double.infinity;
    return SingleChildScrollView(
      child: Column(
        children: [
          TicketView(
            backgroundPadding:
                EdgeInsets.symmetric(vertical: 24, horizontal: 40),
            backgroundColor: mainCTA,
            contentBackgroundColor: themeChange ? darkBar : lightBar,
            contentPadding: EdgeInsets.symmetric(vertical: 44, horizontal: 20),
            drawArc: true,
            triangleAxis: Axis.vertical,
            borderRadius: 6,
            drawDivider: true,
            trianglePos: .65,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              width: ticketSize,
              height: 250, //400
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       "پلاک وسيله نقليه انتخابی",
                  //       style: TextStyle(
                  //           fontFamily: mainFaFontFamily,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ],
                  // ),
                  // PlateViewer(
                  //   plate0: finalSelectedPlateToSending["plate0"],
                  //   plate1: finalSelectedPlateToSending["plate1"],
                  //   plate2: finalSelectedPlateToSending["plate2"],
                  //   plate3: finalSelectedPlateToSending["plate3"],
                  //   themeChange: themeChange,
                  // ),
                  // SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        noticeMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0.w),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   textDirection: TextDirection.rtl,
                  //   children: [
                  //     Text(
                  //       ":ساعت ورود",
                  //       style: TextStyle(
                  //           fontFamily: mainFaFontFamily,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Text(
                  //       "$startTime",
                  //       style: TextStyle(
                  //         fontFamily: mainFaFontFamily,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   textDirection: TextDirection.rtl,
                  //   children: [
                  //     Text(
                  //       ":ساعت خروج",
                  //       style: TextStyle(
                  //           fontFamily: mainFaFontFamily,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Text(
                  //       "$endTime",
                  //       style: TextStyle(
                  //         fontFamily: mainFaFontFamily,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      Column(
                        children: [
                          Text(
                            "تاریخ رزرو",
                            style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            datePickedByUser.toString(),
                            style: TextStyle(
                              fontFamily: mainFaFontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          onPressed: pressedDate,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(mainSectionCTA)),
                          icon: Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            openCalender,
                            style: TextStyle(
                                fontFamily: mainFaFontFamily, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(8.0),
                      color: primarySubmitBtnColor,
                      child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: isLoad ? null : sendToSubmit,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isLoad
                                  ? CupertinoActivityIndicator()
                                  : Text(
                                      "تایید رزرو",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: loginBtnTxtColor,
                                          fontFamily: mainFaFontFamily,
                                          fontSize: btnSized,
                                          fontWeight: FontWeight.bold),
                                    ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
