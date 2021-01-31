import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class MiniReserveHistory extends StatelessWidget {
  const MiniReserveHistory(
      {this.status,
      this.plate0,
      this.plate1,
      this.plate2,
      this.plate3,
      this.buildingName,
      this.startedTime,
      this.endedTime,
      this.slotNo});
  final int status;
  final String plate0;
  final String plate1;
  final String plate2;
  final String plate3;
  final String buildingName;
  final String startedTime;
  final String endedTime;
  final String slotNo;

  @override
  Widget build(BuildContext context) {
    final specificReserveStatusColor = status == -1
        ? Colors.orange
        : status == 0
            ? Colors.green[700]
            : status == 1
                ? Colors.red
                : Colors.white;
    return Container(
      width: double.infinity,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        image: DecorationImage(
          image: AssetImage("assets/images/back.jpg"),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.srcOver),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: specificReserveStatusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 185,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            border:
                                Border.all(color: Colors.black38, width: 1.8),
                            borderRadius: BorderRadius.circular(4)),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 35,
                                height: 50,
                                color: Colors.blue.shade800,
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/iranFlag.png",
                                        width: 35),
                                    Text(
                                      "I.R.",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                    Text(
                                      "IRAN",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                plate0,
                                style: TextStyle(
                                    fontFamily: mainFaFontFamily,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                plate1,
                                style: TextStyle(
                                    fontFamily: mainFaFontFamily,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                plate2,
                                style: TextStyle(
                                    fontFamily: mainFaFontFamily,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              VerticalDivider(
                                  width: 0, color: Colors.black, thickness: 3),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                plate3,
                                style: TextStyle(
                                    fontFamily: mainFaFontFamily,
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            " ساختمان: $buildingName",
                            style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                color: Colors.white),
                          ),
                          Text(
                            " جایگاه: $slotNo",
                            style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "از",
                        style: TextStyle(
                            fontFamily: mainFaFontFamily, color: Colors.white),
                      ),
                      Text(
                        startedTime,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily, color: Colors.white),
                      ),
                      Text(
                        "تا",
                        style: TextStyle(
                            fontFamily: mainFaFontFamily, color: Colors.white),
                      ),
                      Text(
                        endedTime,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
