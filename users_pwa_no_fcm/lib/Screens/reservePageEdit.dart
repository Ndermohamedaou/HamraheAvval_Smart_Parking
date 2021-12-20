import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
// import 'package:payausers/Screens/addingPlateIntro.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/reserveController.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:provider/provider.dart';

// import 'package:payausers/ExtractedWidgets/pagesOfReserve/calender.dart';
// import 'package:payausers/ExtractedWidgets/pagesOfReserve/takenTime.dart';
import 'package:payausers/ExtractedWidgets/pagesOfReserve/summery.dart';

// Declear Specific page index for controller
// int curIndex = 0;
// Show which date clicked and prepare to send it to API
String datePickedByUser = "";
// Timing
// int startTime = 1;
// int endTime = startTime + 1;
// Plate
String selectedPlate = "";
bool isLoadingReserve = false;

// Bydefault selected user plate by string form
// String bydefaultSelectedString = "";
// final selected plate by string for,
// String finalSelectedString = "";
// Map of final selected plate
// Map finalSelectedPlate = {
//   "plate0": "",
//   "plate1": "",
//   "plate2": "",
//   "plate3": "",
// };

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

  @override
  void initState() {
    _controller = PageController();
    isLoadingReserve = false;
    // curIndex = 0;
    datePickedByUser = "";
    // startTime = 1;
    // endTime = startTime + 1;
    selectedPlate = "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    ReservesModel reservesModel = Provider.of<ReservesModel>(context);
    PlatesModel plateModel = Provider.of<PlatesModel>(context);

    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      headerTextStyle: TextStyle(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
          fontSize: 18),
      // تنظیمات امروز
      headerTodayBackgroundColor: HexColor("#354F4F"),
      headerTodayTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      headerBackgroundColor: themeChange.darkTheme ? darkBar : lightBar,
      // background of days of the week
      weekCaptionsBackgroundColor: mainCTA,
      // background of years and month
      daysBackgroundColor:
          themeChange.darkTheme ? HexColor("#121C1C") : Colors.white,
      daysTextStyle: TextStyle(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
          fontSize: 18),
      selectedDayBackgroundColor: mainSectionCTA,
      yearSelectionBackgroundColor:
          themeChange.darkTheme ? mainBgColorDark : mainBgColorLight,
      // For years range
      yearSelectionTextStyle:
          TextStyle(color: themeChange.darkTheme ? Colors.white : Colors.black),
      yearSelectionHighlightTextStyle:
          TextStyle(color: themeChange.darkTheme ? Colors.white : Colors.black),
      yearSelectionHighlightBackgroundColor:
          themeChange.darkTheme ? darkBar : lightBar,
      // For month range
      monthSelectionBackgroundColor:
          themeChange.darkTheme ? mainBgColorDark : mainBgColorLight,
      monthSelectionTextStyle:
          TextStyle(color: themeChange.darkTheme ? Colors.white : Colors.black),
      monthSelectionHighlightTextStyle:
          TextStyle(color: themeChange.darkTheme ? Colors.white : Colors.black),
      monthSelectionHighlightBackgroundColor:
          themeChange.darkTheme ? darkBar : lightBar,
      disabledDayBackgroundColor:
          themeChange.darkTheme ? HexColor("#234A4F") : null,
      disabledDayTextStyle: TextStyle(
          color: themeChange.darkTheme ? Colors.white54 : null, fontSize: 18),

      datetime: "${DateTime.now()}",
      currentDayBackgroundColor: mainCTA,
      fontFamily: mainFaFontFamily,
      minDatetime: "${DateTime.now()}",
      onChange: (String oldDate, String newDate) {
        setState(() {
          datePickedByUser = newDate;
          // print("This is new date $newDate");
        });
        Navigator.pop(context);
      },
    ).init();

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
    // final plateViewerInModal = ListView.builder(
    //   itemCount: plateModel.length,
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) {
    //     if (plateModel[index]['status'] == 1)
    //       return (GestureDetector(
    //         onTap: () {
    //           setState(() {
    //             finalSelectedString = plateModel[index]['plate_en'];
    //             finalSelectedPlate = {
    //               "plate0": plateModel[index]['plate0'],
    //               "plate1": plateModel[index]['plate1'],
    //               "plate2": plateModel[index]['plate2'],
    //               "plate3": plateModel[index]['plate3'],
    //             };
    //             Navigator.pop(context);
    //           });
    //         },
    //         child: PlateViewer(
    //             plate0: plateModel[index]['plate0'] != null
    //                 ? plateModel[index]['plate0']
    //                 : "-",
    //             plate1: plateModel[index]['plate1'] != null
    //                 ? plateModel[index]['plate1']
    //                 : "-",
    //             plate2: plateModel[index]['plate2'] != null
    //                 ? plateModel[index]['plate2']
    //                 : "-",
    //             plate3: plateModel[index]['plate3'] != null
    //                 ? plateModel[index]['plate3']
    //                 : "-",
    //             themeChange: themeChange.darkTheme),
    //       ));
    //     else
    //       Text(
    //         "شما هیچ پلاک تایید شده ای از سوی سامانه ندارید",
    //         style: TextStyle(fontFamily: mainFaFontFamily, color: Colors.white),
    //         textDirection: TextDirection.ltr,
    //       );
    //   },
    // );

    // // Waiting LottieFile
    // Widget searchingProcess = Column(
    //   children: [
    //     Lottie.asset("assets/lottie/searching.json"),
    //     Text(searchingProcessText,
    //         style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
    //   ],
    // );
    // // If any plate had exists
    // Widget plateContext =
    //     plateModel != [] ? plateViewerInModal : searchingProcess;
    // // else
    // Widget addPlateNotExists = Column(
    //   children: [
    //     SizedBox(height: 25),
    //     Directionality(
    //       textDirection: TextDirection.rtl,
    //       child: ElevatedButton.icon(
    //         onPressed: () => Navigator.pushNamed(context, "/addingPlateIntro"),
    //         style: ButtonStyle(
    //             backgroundColor: MaterialStateProperty.all(mainCTA)),
    //         icon: Icon(Icons.add, size: 18),
    //         label: Text(
    //           "اضافه کردن پلاک",
    //           style: TextStyle(fontFamily: mainFaFontFamily),
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 50),
    //   ],
    // );
    // // In final:
    // Widget finalPlateContext =
    //     plateModel.length != 0 ? plateContext : addPlateNotExists;

    // // By default plate for Reserve
    // Widget byDefaultSelectedPlate =
    //     plateModel.isEmpty || plateModel[0]["status"] == 0
    //         ? Text(
    //             emptyUserPlate,
    //             style: TextStyle(
    //               fontFamily: mainFaFontFamily,
    //             ),
    //           )
    //         : PlateViewer(
    //             plate0: plateModel[0]['plate0'],
    //             plate1: plateModel[0]['plate1'],
    //             plate2: plateModel[0]['plate2'],
    //             plate3: plateModel[0]['plate3'],
    //             themeChange: themeChange.darkTheme,
    //           );
    // // String form of default user plate
    // bydefaultSelectedString =
    //     plateModel.isEmpty ? "" : plateModel[0]['plate_en'];
    // // Widget form of default user plate
    // Widget byDefaultPlateGraphy = plateModel != []
    //     ? byDefaultSelectedPlate
    //     : Text(
    //         emptyUserPlate,
    //         style: TextStyle(
    //           fontFamily: mainFaFontFamily,
    //         ),
    //       );

    // Widget selectedPlateGraphy = PlateViewer(
    //   plate0: finalSelectedPlate['plate0'],
    //   plate1: finalSelectedPlate['plate1'],
    //   plate2: finalSelectedPlate['plate2'],
    //   plate3: finalSelectedPlate['plate3'],
    //   themeChange: themeChange.darkTheme,
    // );

    // Widget finalPlateViewInContainer =
    //     finalSelectedString == "" ? byDefaultPlateGraphy : selectedPlateGraphy;

    // Map defaultUserPlateMap = plateModel.isEmpty
    //     ? {
    //         "plate0": "-",
    //         "plate1": "-",
    //         "plate2": "-",
    //         "plate3": "-",
    //       }
    //     : plateModel[0]["status"] == 1
    //         ? {
    //             "plate0": plateModel[0]['plate0'],
    //             "plate1": plateModel[0]['plate1'],
    //             "plate2": plateModel[0]['plate2'],
    //             "plate3": plateModel[0]['plate3'],
    //           }
    //         : {
    //             "plate0": "-",
    //             "plate1": "-",
    //             "plate2": "-",
    //             "plate3": "-",
    //           };

    // final switchingPlate = finalSelectedString == ""
    //     ? defaultUserPlateMap
    //     : {
    //         "plate0": finalSelectedPlate['plate0'],
    //         "plate1": finalSelectedPlate['plate1'],
    //         "plate2": finalSelectedPlate['plate2'],
    //         "plate3": finalSelectedPlate['plate3'],
    //       };

    void gettingReserve() async {
      if (datePickedByUser.isNotEmpty) {
        setState(() => isLoadingReserve = true);

        await Future.delayed(Duration(seconds: 2));
        List plate = plateModel.plates;
        final pickDate = datePickedByUser.split("/");

        final strDateTimeStart = "${pickDate[0]}-${pickDate[1]}-${pickDate[2]}";
        final strDateTimeEnd = "${pickDate[0]}-${pickDate[1]}-${pickDate[2]} ";

        // final reallyPlate = finalSelectedString == ""
        //     ? bydefaultSelectedString
        //     : finalSelectedString;
        // print("$strDateTimeStart \n $strDateTimeEnd \n $reallyPlate ");

        // Go to controller
        if (plate.isNotEmpty) {
          reserveMe(
            context: context,
            st: strDateTimeStart,
            et: strDateTimeEnd,
            // pt: reallyPlate,
          );
          setState(() => isLoadingReserve = false);
        } else {
          customAlert(
            context: context,
            alertIcon: Icons.close_sharp,
            borderColor: Colors.red,
            iconColor: Colors.red,
            acceptPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/addingPlateIntro");
            },
            ignorePressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
            title: failedReserveMsgTitle,
            desc: failedReserveMsgDesc,
          );
          setState(() => isLoadingReserve = false);
        }

        reservesModel.fetchReservesData;
      } else {
        showStatusInCaseOfFlush(
            context: context,
            title: defectiveInfo,
            msg: defectiveInfoMsg,
            iconColor: Colors.red,
            icon: Icons.details_outlined);
      }
    }

    // List<Widget> mainTakenReserve = [
    //   // DateUserPicker(pressedDate: openCalend, pickedDateText: datePickedByUser),
    //   // TimerPicker(
    //   //   startTimeText: startTime,
    //   //   endTimeText: endTime,
    //   //   changeStartTime: (startHour) => setState(() {
    //   //     startTime = startHour;
    //   //     if (startTime != 24)
    //   //       endTime = startTime + 1;
    //   //     else
    //   //       endTime = 1;
    //   //   }),
    //   //   changeEndTime: (endHour) => setState(() => endTime = endHour),
    //   // ),
    //   // PlatePicker(
    //   //   mainContext: finalPlateContext,
    //   //   plateForShow: finalPlateViewInContainer,
    //   // ),
    //   Summery(
    //     themeChange: themeChange.darkTheme,
    //     pressedDate: openCalend,
    //     datePickedByUser: datePickedByUser != "" ? datePickedByUser : "-",
    //     // startTime: startTime != 0 ? startTime : "-",
    //     // endTime: endTime != 0 ? endTime : "-",
    //     // finalSelectedPlateToSending: switchingPlate,
    //     isLoad: isLoadingReserve,
    //     sendToSubmit: () => gettingReserve(),
    //   )
    // ];

    // List appBarTitleSpecific = [summery];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
        ),
        title: Text(
          summery,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            color: themeChange.darkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Summery(
          themeChange: themeChange.darkTheme,
          pressedDate: openCalend,
          datePickedByUser: datePickedByUser != "" ? datePickedByUser : "-",
          // startTime: startTime != 0 ? startTime : "-",
          // endTime: endTime != 0 ? endTime : "-",
          // finalSelectedPlateToSending: switchingPlate,
          isLoad: isLoadingReserve,
          sendToSubmit: () => gettingReserve(),
        ),
      ),
    );
  }
}
