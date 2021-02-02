import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:payausers/controller/reserveController.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

// import 'package:flushbar/flushbar.dart';
import 'package:payausers/ExtractedWidgets/pagesOfReserve/calender.dart';
import 'package:payausers/ExtractedWidgets/pagesOfReserve/takenTime.dart';
import 'package:payausers/ExtractedWidgets/pagesOfReserve/plate.dart';
import 'package:payausers/ExtractedWidgets/pagesOfReserve/summery.dart';

// Declear Specific page index for controller
int curIndex = 0;
// Show which date clicked and prepare to send it to API
String datePickedByUser = "";
// Timing
String startTime = "";
String endTime = "";
// Plate
String selectedPlate = "";
List userPlates = [];

// Bydefault selected user plate by string form
String bydefaultSelectedString = "";
// final selected plate by string for,
String finalSelectedString = "";
// Map of final selected plate
Map finalSelectedPlate = {
  "plate0": "",
  "plate1": "",
  "plate2": "",
  "plate3": "",
};

dynamic themeChange;

class ReserveEditaion extends StatefulWidget {
  @override
  _ReserveEditaionState createState() => _ReserveEditaionState();
}

class _ReserveEditaionState extends State<ReserveEditaion> {
  // Specific Page Controller from client
  var _controller = PageController();

  // our text controller‍
  final TextEditingController textEditingController = TextEditingController();
  PersianDatePickerWidget persianDatePicker;

  Timer _timer;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: "${DateTime.now()}",
      fontFamily: mainFaFontFamily,
      onChange: (String oldDate, String newDate) {
        setState(() {
          datePickedByUser = newDate;
          // print("This is new date $newDate");
        });
      },
    ).init();

    // This func related to getting
    // user plate function in specific Controller
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      gettingUserPlateFunc();
    });
    gettingUserPlateFunc();
  }

  void gettingUserPlateFunc() {
    gettingMyPlates().then((plate) {
      setState(() {
        userPlates = plate;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    curIndex = 0;
    datePickedByUser = "";
    startTime = "";
    endTime = "";
    selectedPlate = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);

    // Open Persian Calender view function
    void openCalend() {
      FocusScope.of(context).requestFocus(new FocusNode());
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return persianDatePicker;
          });
    }

    // Plate Viewer in CUPERTINO Modal
    final plateViewerInModal = ListView.builder(
      itemCount: userPlates.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              finalSelectedString = userPlates[index]['plate_en'];
              finalSelectedPlate = {
                "plate0": userPlates[index]['plate0'],
                "plate1": userPlates[index]['plate1'],
                "plate2": userPlates[index]['plate2'],
                "plate3": userPlates[index]['plate3'],
              };
              Navigator.pop(context);
            });
          },
          child: (Container(
            child: PlateViewer(
                plate0: userPlates[index]['plate0'] != null
                    ? userPlates[index]['plate0']
                    : "-",
                plate1: userPlates[index]['plate1'] != null
                    ? userPlates[index]['plate1']
                    : "-",
                plate2: userPlates[index]['plate2'] != null
                    ? userPlates[index]['plate2']
                    : "-",
                plate3: userPlates[index]['plate3'] != null
                    ? userPlates[index]['plate3']
                    : "-",
                themeChange: themeChange.darkTheme),
          )),
        );
      },
    );

    // Waiting LottieFile
    Widget searchingProcess = Column(
      children: [
        Lottie.asset("assets/lottie/searching.json"),
        Text(searchingProcessText,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );
    // If any plate had exists
    Widget plateContext =
        userPlates != [] ? plateViewerInModal : searchingProcess;
    // else
    Widget addPlateNotExists = Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, "/addUserplateAlternative"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(HexColor("#6f03fc"))),
            icon: Icon(Icons.add, size: 18),
            label: Text(
              "اضافه کردن پلاک",
              style: TextStyle(fontFamily: mainFaFontFamily),
            ),
          ),
        ),
      ],
    );
    // In final:
    Widget finalPlateContext =
        userPlates.length != 0 ? plateContext : addPlateNotExists;

    // ByDefault plate for Reserve
    Widget ByDefaultSelectedPlate = userPlates.isEmpty
        ? Text(
            emptyUserPlate,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
            ),
          )
        : PlateViewer(
            plate0: userPlates[0]['plate0'],
            plate1: userPlates[0]['plate1'],
            plate2: userPlates[0]['plate2'],
            plate3: userPlates[0]['plate3'],
            themeChange: themeChange.darkTheme,
          );
    // String form of default user plate
    bydefaultSelectedString =
        userPlates.isEmpty ? "" : userPlates[0]['plate_en'];
    // Widget form of default user plate
    Widget byDefaultPlateGraphy = userPlates != []
        ? ByDefaultSelectedPlate
        : Text(
            emptyUserPlate,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
            ),
          );

    Widget selectedPlateGraphy = PlateViewer(
      plate0: finalSelectedPlate['plate0'],
      plate1: finalSelectedPlate['plate1'],
      plate2: finalSelectedPlate['plate2'],
      plate3: finalSelectedPlate['plate3'],
      themeChange: themeChange.darkTheme,
    );

    Widget finalPlateViewInContainer =
        finalSelectedString == "" ? byDefaultPlateGraphy : selectedPlateGraphy;

    Map defaultUserPlateMap = userPlates.isEmpty
        ? {
            "plate0": "-",
            "plate1": "-",
            "plate2": "-",
            "plate3": "-",
          }
        : {
            "plate0": userPlates[0]['plate0'],
            "plate1": userPlates[0]['plate1'],
            "plate2": userPlates[0]['plate2'],
            "plate3": userPlates[0]['plate3'],
          };

    final switchingPlate = finalSelectedString == ""
        ? defaultUserPlateMap
        : {
            "plate0": finalSelectedPlate['plate0'],
            "plate1": finalSelectedPlate['plate1'],
            "plate2": finalSelectedPlate['plate2'],
            "plate3": finalSelectedPlate['plate3'],
          };

    void gettingReserve() {
      final pickDate = datePickedByUser.split("/");

      final strDateTimeStart =
          "${pickDate[0]}-${pickDate[1]}-${pickDate[2]} $startTime";
      final strDateTimeEnd =
          "${pickDate[0]}-${pickDate[1]}-${pickDate[2]} $endTime";

      final reallyPlate = finalSelectedString == ""
          ? bydefaultSelectedString
          : finalSelectedString;

      // print("$strDateTimeStart \n $strDateTimeEnd \n $reallyPlate ");

      reserveMe(
          context: context,
          st: strDateTimeEnd,
          et: strDateTimeEnd,
          pt: reallyPlate,
          themeChange: themeChange.darkTheme);
    }

    List<Widget> mainTakenReserve = [
      DateUserPicker(pressedDate: openCalend, pickedDateText: datePickedByUser),
      TimerPicker(
        starterTimePressed: () {
          DatePicker.showTimePicker(
            context,
            locale: LocaleType.fa,
            showTitleActions: true,
            showSecondsColumn: false,
            currentTime: DateTime.now(),
            onChanged: (date) {
              // print(date);
            },
            onConfirm: (date) {
              setState(() {
                startTime = "${date.hour}:${date.minute}";
              });
            },
          );
        },
        endTimePressed: () {
          DatePicker.showTimePicker(
            context,
            locale: LocaleType.fa,
            showTitleActions: true,
            showSecondsColumn: false,
            currentTime: DateTime.now(),
            onChanged: (date) {
              // print(date);
            },
            onConfirm: (date) {
              setState(() {
                endTime = "${date.hour}:${date.minute}";
              });
            },
          );
        },
        startTimeText: startTime,
        endTimeText: endTime,
      ),
      PlatePicker(
        mainContext: finalPlateContext,
        plateForShow: finalPlateViewInContainer,
      ),
      Summery(
        themeChange: themeChange.darkTheme,
        datePickedByUser: datePickedByUser,
        startTime: startTime,
        endTime: endTime,
        finalSelectedPlateToSending: switchingPlate,
        sendToSubmit: () {
          gettingReserve();
        },
      )
    ];

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (pageChanged) {
            setState(() {
              curIndex = pageChanged;
            });
          },
          // Check list top for more container shower
          children: mainTakenReserve,
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Material(
                color: Colors.blue, // button color
                child: InkWell(
                  splashColor: Colors.blue[300], // inkwell color
                  child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  onTap: () {
                    if (curIndex > 0 && curIndex <= 3) {
                      setState(() {
                        curIndex -= 1;
                      });
                      if (_controller.hasClients) {
                        _controller.animateToPage(curIndex,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.decelerate);
                      }
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.date_range_outlined,
                    color: curIndex == 0 ? Colors.blue : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.timer_outlined,
                    color: curIndex == 1 ? Colors.blue : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.view_carousel_outlined,
                    color: curIndex == 2 ? Colors.blue : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.featured_play_list_outlined,
                    color: curIndex == 3 ? Colors.blue : null,
                  ),
                ),
              ],
            ),
            ClipOval(
              child: Material(
                color: Colors.blue, // button color
                child: InkWell(
                  splashColor: Colors.blue[300], // inkwell color
                  child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )),
                  onTap: () {
                    if (curIndex >= 0 && curIndex < 3) {
                      setState(() {
                        curIndex += 1;
                      });
                      if (_controller.hasClients) {
                        _controller.animateToPage(curIndex,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.decelerate);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}