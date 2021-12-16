import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ExtractedWidgets/customClipOval.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ReservedTab extends StatefulWidget {
  const ReservedTab();

  @override
  _ReservedTabState createState() => _ReservedTabState();
}

int filtered = 0;
ReservesModel reservesModel;
PlatesModel platesModel;
Timer _onRefreshReservesPerMin;

class _ReservedTabState extends State<ReservedTab>
    with AutomaticKeepAliveClientMixin {
  // Timer for refresh in a min, if data had any change.
  @override
  void initState() {
    _onRefreshReservesPerMin = Timer.periodic(Duration(minutes: 1), (timer) {
      reservesModel.fetchReservesData;
    });
    super.initState();
  }

  @override
  void dispose() {
    _onRefreshReservesPerMin.cancel();
    super.dispose();
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

    // UI loading or Error Class
    LogLoading logLoadingWidgets = LogLoading();
    // // Prepare class for getting right plate from database
    // PreparedPlate preparedPlate = PreparedPlate();
    // Controller of Instant reserve
    InstantReserve instantReserve = InstantReserve();
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

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
                              aggreementPressed: () => Navigator.pushNamed(
                                  context, "/reserveEditaion"),
                            ),
                            SizedBox(width: 10),
                            // Stream Instant reserve
                            StreamBuilder(
                                stream:
                                    streamAPI.getUserCanInstantReserveReal(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.hasData) {
                                    Map status = jsonDecode(snapshot.data);
                                    print(status["status"]);
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

                  final reserveList = reservesModel.reserves.reversed.toList();
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
