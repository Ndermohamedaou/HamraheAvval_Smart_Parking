import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:payausers/ExtractedWidgets/customClipOval.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/InstantReserveBtn.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/CustomRichText.dart';
import 'package:payausers/ExtractedWidgets/filterModal.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/reserveDetailsInModal.dart';
import 'package:payausers/ExtractedWidgets/reserveHistoryView.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/cancelingReserveController.dart';
import 'package:payausers/controller/instentReserveController.dart';
import 'package:payausers/Model/streamAPI.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:sizer/sizer.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ReservedTab extends StatefulWidget {
  const ReservedTab();

  @override
  _ReservedTabState createState() => _ReservedTabState();
}

int filtered = 0;
ReservesModel reservesModel;
PlatesModel platesModel;
Timer _onRefreshReservesPerMin;
List selectedDays = [];

class _ReservedTabState extends State<ReservedTab>
    with AutomaticKeepAliveClientMixin {
  // Timer for refresh in a min, if data had any change.
  @override
  void initState() {
    getAWeek();
    _onRefreshReservesPerMin = Timer.periodic(Duration(minutes: 1), (timer) {
      reservesModel.fetchReservesData;
    });
    super.initState();
  }

  @override
  void dispose() {
    _onRefreshReservesPerMin.cancel();
    selectedDays = [];
    super.dispose();
  }

  void getAWeek() {
    /// Get next week that will start with Saturday.
    ///
    /// With this function you can get a free week from Saturday to Thursday.
    /// This DateTime shall be Persian DateTime to show users, what is their selected dates.
    ///
    Jalali now = Jalali.now();
    var weekDay = now.weekDay;
    var firstOfTheWeek = now - weekDay + 8;
    for (var i = 0; i < 6; i++) {
      final date = firstOfTheWeek + i;
      String year = "${date.year}".toPersianDigit();
      String month = "${date.month}".toPersianDigit();
      String day = "${date.day}".toPersianDigit();
      selectedDays.add({
        "value": "${date.year}-${date.month}-${date.day}",
        "label": "$year-$month-$day"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Reserve model for fetch and Reserve list getter
    reservesModel = Provider.of<ReservesModel>(context);
    platesModel = Provider.of<PlatesModel>(context);
    // StreamAPI only for Instant reserve per 30 second
    StreamAPI streamAPI = StreamAPI();
    ApiAccess api = ApiAccess();

    // print(reservesModel.reserves["reserved_days"]);
    // [date1, date2, etc...]

    // UI loading or Error Class
    LogLoading logLoadingWidgets = LogLoading();
    // // Prepare class for getting right plate from database
    // PreparedPlate preparedPlate = PreparedPlate();
    // Controller of Instant reserve
    InstantReserve instantReserve = InstantReserve();
    FlutterSecureStorage lds = FlutterSecureStorage();
    CancelReserve cancelReserve = CancelReserve();

    void openDetailsInModal({
      reservID,
      reserveStatus,
      List plate,
      startTime,
      endTime,
      building,
      slot,
    }) {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: ReserveInDetails(
            plate: plate,
            reserveStatusDesc: reserveStatus,
            startTime: startTime,
            endTime: endTime,
            building: building,
            slot: slot,
            themeChange: themeChange,
            delReserve: () {
              cancelReserve.delReserve(reserveID: reservID, context: context);
              // Refetch data in Providers
              reservesModel.fetchReservesData;
            },
          ),
        ),
      );
    }

    void instentReserveProcess() async {
      final token = await lds.read(key: "token");
      final result = await instantReserve.instantReserve(token: token);

      if (result != "") {
        // Update Reserves in Provider
        reservesModel.fetchReservesData;
        rAlert(
            context: context,
            tAlert: AlertType.success,
            title: titleResultInstantReserve,
            desc:
                "رزرو لحظه ای شما با موفقیت انجام شد و در موقعیت $result می تواند پارک خود را انجام دهید",
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")));
      } else {
        rAlert(
            context: context,
            tAlert: AlertType.error,
            title: titleResultInstantReserve,
            desc: descFailedInstantReserve,
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")));
      }
    }

    // Instant reserve in Modal
    instantResrver() {
      // Create new time now
      DateTime dateTime = DateTime.now();
      final timeNow = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

      customAlert(
          context: context,
          alertIcon: Icons.access_time_outlined,
          borderColor: Colors.blue,
          iconColor: Colors.blue,
          title: "رزرو لحظه ای",
          desc:
              "آیا میخواید امروز در این زمان $timeNow رزرو لحظه ای خود را انجام دهید؟ ",
          acceptPressed: () {
            instentReserveProcess();
            Navigator.pop(context);
          },
          ignorePressed: () => Navigator.pop(context));
    }

    void filterSection() {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text("فیلتر نتایج",
                      style: TextStyle(
                        fontFamily: mainFaFontFamily,
                        color: mainCTA,
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: mainCTA,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              FilterMenu(
                text: "نمایش 5 رزرو",
                filterPressed: () {
                  setState(() => filtered = 5);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۲۰ رزرو",
                filterPressed: () {
                  setState(() => filtered = 20);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۵۰ رزرو",
                filterPressed: () {
                  setState(() => filtered = 50);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش تمام رزروها",
                filterPressed: () {
                  setState(() => filtered = 0);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.0.h),
            ],
          ),
        ),
      );
    }

    void _showMultiSelect(BuildContext context) async {
      // print(selectedDays);
      final listOfDays = selectedDays
          .map((day) => MultiSelectItem(day["value"], day["label"]))
          .toList();

      await showModalBottomSheet(
        isScrollControlled: true, // required for min/max child size
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MultiSelectBottomSheet(
              items: listOfDays,
              initialValue: reservesModel.reserves["reserved_days"],
              onConfirm: (values) async {
                final lStorage = FlutterSecureStorage();
                final userToken = await lStorage.read(key: "token");
                final res =
                    await api.reserveByUser(token: userToken, days: values);
                reservesModel.fetchReservesData;
                if (res == "200") {
                  rAlert(
                      context: context,
                      onTapped: () {
                        Navigator.pop(context);
                      },
                      tAlert: AlertType.success,
                      title: titleOfReserve,
                      desc: resultOfReserve);
                } else {
                  rAlert(
                      context: context,
                      onTapped: () => Navigator.pop(context),
                      tAlert: AlertType.warning,
                      title: titleOfFailedReserve,
                      desc: descOfFailedReserve);
                }
              },
              checkColor: mainCTA,
              itemsTextStyle:
                  TextStyle(fontFamily: mainFaFontFamily, fontSize: 20.0),
              selectedItemsTextStyle:
                  TextStyle(fontFamily: mainFaFontFamily, fontSize: 20.0),
              maxChildSize: 0.8,
              title: Text("انتخاب یک یا چند روز از هفته",
                  textAlign: TextAlign.right,
                  style:
                      TextStyle(fontFamily: mainFaFontFamily, fontSize: 25.0)),
              cancelText: Text("انصراف",
                  style:
                      TextStyle(fontFamily: mainFaFontFamily, fontSize: 24.0)),
              confirmText: Text("تایید",
                  style:
                      TextStyle(fontFamily: mainFaFontFamily, fontSize: 24.0)),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reserveTextTitle,
                          style: TextStyle(
                              fontFamily: mainFaFontFamily,
                              fontSize: subTitleSize,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomClipOval(
                              icon: Icons.add,
                              firstColor: mainCTA,
                              secondColor: mainSectionCTA,
                              aggreementPressed: () =>
                                  _showMultiSelect(context),
                            ),
                            SizedBox(width: 10),
                            // Stream Instant reserve
                            StreamBuilder(
                                stream:
                                    streamAPI.getUserCanInstantReserveReal(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.hasData) {
                                    Map status = jsonDecode(snapshot.data);
                                    return IsInstantReserve().getInstantButton(
                                        status["status"],
                                        () => instantResrver());
                                  }

                                  if (snapshot.hasError)
                                    return SizedBox();
                                  else
                                    return SizedBox();
                                }),
                          ],
                        ),
                      ]),
                ),
              ),
              Builder(
                builder: (_) {
                  if (reservesModel.reserveState == FlowState.Loading)
                    return logLoadingWidgets.waitCircularProgress();

                  if (reservesModel.reserveState == FlowState.Error)
                    return logLoadingWidgets.internetProblem;

                  List reserveList =
                      reservesModel.reserves["reserves"].reversed.toList();

                  if (reserveList.isEmpty)
                    return logLoadingWidgets.notFoundReservedData(msg: "رزرو");

                  return Column(
                    children: [
                      filtered != 0
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerRight,
                              child: CustomRichText(
                                themeChange: themeChange,
                                textOne: "نمایش $filtered ",
                                textTwo: "از ${reserveList.length} رزرو",
                              ),
                            )
                          : SizedBox(),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: filtered == 0
                            ? reserveList.length
                            : reserveList.length > filtered
                                ? filtered
                                : reserveList.length,
                        itemBuilder: (BuildContext context, index) {
                          return SingleChildScrollView(
                            child: GestureDetector(
                              onTap: () {
                                // Update user reserves in provider
                                reservesModel.fetchReservesData;

                                openDetailsInModal(
                                  reservID: reserveList[index]["id"],
                                  reserveStatus: reserveList[index]['status'],
                                  // plate: preparedPlate.preparePlateInReserve(
                                  //     rawPlate: reserveList[index]['plate']),
                                  plate: [],
                                  building:
                                      reserveList[index]["building"] != null
                                          ? reserveList[index]["building"]
                                          : "",
                                  slot: reserveList[index]["slot"],
                                  startTime: reserveList[index]
                                      ["reserveTimeStart"],
                                  endTime: reserveList[index]["reserveTimeEnd"],
                                );
                              },
                              child: (Column(
                                children: [
                                  ReserveHistoryView(
                                    historyBuildingName:
                                        reserveList[index]["building"] != null
                                            ? reserveList[index]["building"]
                                            : "",
                                    reserveStatusColor: reserveList[index]
                                        ['status'],
                                    historySlotName: reserveList[index]["slot"],
                                    historyStartTime: reserveList[index]
                                        ["reserveTimeStart"],
                                    historyEndTime: reserveList[index]
                                        ["reserveTimeEnd"],
                                  ),
                                ],
                              )),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: reservesModel.reserves.isEmpty
          ? SizedBox()
          : CustomClipOval(
              icon: Icons.filter_alt_outlined,
              firstColor: mainCTA,
              secondColor: mainSectionCTA,
              aggreementPressed: () => filterSection(),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
