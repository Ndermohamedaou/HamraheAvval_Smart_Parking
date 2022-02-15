import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payausers/ExtractedWidgets/reserve_category_separator.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/calculate_next_week.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/spec/enum_state.dart';
import "package:sizer/sizer.dart";
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/instentReserveController.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/instant_reserve_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReserveCategories extends StatefulWidget {
  const ReserveCategories({Key key}) : super(key: key);

  @override
  _ReserveCategoriesState createState() => _ReserveCategoriesState();
}

int filtered = 0;
ReserveWeeks reserveWeeks;
ReservesModel reservesModel;
ReservesByWeek reservesByWeek;
PlatesModel platesModel;
InstantReserveModel instantReserveModel;
AvatarModel localData;
// TODO: Clean this lists after build
List weekly = [];
List list = [];
List instant = [];
// Controller of Instant reserve
InstantReserve instantReserve = InstantReserve();
DateTimeCalculator dateTimeCalculator = DateTimeCalculator();

// Reserve day of week states
List selectedDays = [];
List selectChipList = [];
List<Widget> chipsDate = [];
List<bool> selectedDaysAsBool = [];
Timer _onRefresh;

class _ReserveCategoriesState extends State<ReserveCategories> {
  @override
  void initState() {
    selectedDays = dateTimeCalculator.getAWeek();

    _onRefresh = Timer.periodic(Duration(seconds: 30), (timer) {
      // Update data from the Provider
      reservesByWeek.fetchReserveWeeks;
      reserveWeeks.fetchReserveWeeks;
    });

    super.initState();
  }

  @override
  void dispose() {
    _onRefresh.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Reserve model for fetch and Reserve list getter
    reserveWeeks = Provider.of<ReserveWeeks>(context);
    reservesModel = Provider.of<ReservesModel>(context);
    reservesByWeek = Provider.of<ReservesByWeek>(context);
    platesModel = Provider.of<PlatesModel>(context);
    instantReserveModel = Provider.of<InstantReserveModel>(context);
    localData = Provider.of<AvatarModel>(context);
    // Prepare api with passing token
    ApiAccess api = ApiAccess(localData.userToken);

    // Prepared reserve list from the API
    // TODO: Fix this handy revariable after build
    Map reserves = reserveWeeks.finalReserveWeeks["reserves"] == null
        ? {}
        : reserveWeeks.finalReserveWeeks["reserves"];
    weekly = reserves["weekly"] == null ? [] : reserves["weekly"];
    list = reserves["list"] == null ? [] : reserves["list"];
    instant = reserves["instant"] == null ? [] : reserves["instant"];

    // Reserve by select chips
    reserveByChips(String date) async {
      String responseStatus = "";
      Map message = {};

      Endpoint reserveEndpoint =
          apiEndpointsMap["reserveEndpoint"]["changeDailyReserveStatus"];

      try {
        final result = await api.requestHandler(
            "${reserveEndpoint.route}?date=$date", reserveEndpoint.method, {});

        // Preparing and handling response details
        responseStatus = result["status"];
        message = result["message"];

        if (responseStatus == "success") {
          // If reserve was successful, then update reserves model for getting
          // New week date list.
          reservesModel.fetchReservesData;
          // After getting list of week date, we need to update our week reserve list.
          // For exp: [week1, week2, week3, etc...]
          reserveWeeks.fetchReserveWeeks;

          Navigator.pop(context);
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.success,
              title: message["title"],
              desc: message["desc"]);
        } else if (responseStatus == "warning") {
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.warning,
              title: message["title"],
              desc: message["desc"]);
        } else if (responseStatus == "failed") {
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.error,
              title: message["title"],
              desc: message["desc"]);
        }
      } catch (e) {
        print(e);
        rAlert(
            context: context,
            onTapped: () => Navigator.pop(context),
            tAlert: AlertType.error,
            title: "شکست در انجام عملیات",
            desc:
                "رزرو شما انجام نشد. لطفا ارتباط خود را با سرویس دهنده بررسی کنید.");
      }
    }

    // Fetching data from server to render date chips
    prepareChips() {
      // print("This is ==> ${reservesModel.reserves["reserved_days"]}");
      setState(() {
        selectedDaysAsBool = [];
        chipsDate = [];
      });
      for (var i = 0; i < selectedDays.length; i++) {
        // Checking next week days contained reserve_days API [data].
        // If was contain will return true, else false.
        try {
          selectedDaysAsBool.add(reservesModel.reserves["reserved_days"]
              .contains(selectedDays[i]["value"]));
        } catch (e) {
          // Catch for network connection lost.
          selectedDaysAsBool.add(false);
        }
      }

      for (int i = 0; i < selectedDays.length; i++) {
        chipsDate.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: FilterChip(
            label: Text(
              selectedDays[i]["label"],
              style: TextStyle(fontSize: 20.0, fontFamily: mainFaFontFamily),
            ),
            selected: selectedDaysAsBool[i],
            selectedColor: mainCTA,
            onSelected: (bool value) async {
              setState(() {
                selectedDaysAsBool[i] = !selectedDaysAsBool[i];
              });
              reserveByChips(selectedDays[i]["value"]);
            },
          ),
        ));
      }
    }

    reserveBottomSheet() async {
      prepareChips();
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: Column(
                  children: [
                    SizedBox(height: 1.0.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text("انتخاب یک یا چند روز از هفته",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: mainFaFontFamily,
                                  fontSize: 22.0)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.0.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: chipsDate,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0.h),
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(8.0),
                        color: mainSectionCTA,
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "بستن",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: mainFaFontFamily,
                                fontSize: btnSized,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0.h),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    instentReserveProcess() async {
      final result =
          await instantReserve.instantReserve(token: localData.userToken);

      if (result["status"] == "success") {
        // Update Reserves in Provider
        // If reserve was successful, then update reserves model for getting
        // New week date list.
        reservesModel.fetchReservesData;
        // After getting list of week date, we need to update our week reserve list.
        // For exp: [week1, week2, week3, etc...]
        reserveWeeks.fetchReserveWeeks;
        rAlert(
            context: context,
            tAlert: AlertType.success,
            title: result["message"]["title"],
            desc: result["message"]["desc"],
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")));
      } else {
        rAlert(
            context: context,
            tAlert: AlertType.error,
            title: result["message"]["title"],
            desc: result["message"]["desc"],
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")));
      }
    }

    instantResrver() {
      // Create new time now
      DateTime dateTime = DateTime.now();

      // Create now DateTime to ensure user from choice.
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

    return DefaultTabController(
      length: 3,
      // Default tab will be weekly reserve
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: defaultAppBarColor,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: CustomText(reserveCategoriesTitle),
          leading: IconButton(
            icon: Icon(Iconsax.timer_start),
            onPressed: instantReserveModel.canInstantReserve == 1
                ? () => instantResrver()
                : null,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Iconsax.information,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, "/reserveGuideView"),
            ),
          ],
          bottom: const TabBar(
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: 15,
              ),
              tabs: [
                Tab(
                    icon: Icon(Iconsax.notification_bing),
                    text: "رزرو $instantReserveText"),
                Tab(
                  icon: Icon(Iconsax.calendar_tick),
                  text: "رزرو $weeklyReserveText",
                ),
                Tab(
                    icon: Icon(Iconsax.driver),
                    text: "رزرو $staticReserveText"),
              ]),
        ),
        body: TabBarView(children: [
          ReserveCategorySeparator(
            reserveWeeks: reserveWeeks,
            reservesByWeek: reservesByWeek,
            reserveListByType: instant,
            reserveTypeName: "instant",
          ),
          ReserveCategorySeparator(
            reserveWeeks: reserveWeeks,
            reservesByWeek: reservesByWeek,
            reserveListByType: weekly,
            reserveTypeName: "weekly",
          ),
          ReserveCategorySeparator(
            reserveWeeks: reserveWeeks,
            reservesByWeek: reservesByWeek,
            reserveListByType: list,
            reserveTypeName: "list",
          ),
        ]),
        floatingActionButton:
            reserveWeeks.reserveWeeksState == FlowState.Error ||
                    reserveWeeks.reserveWeeksState == FlowState.Loading ||
                    !reserveWeeks.finalReserveWeeks["canReserve"]
                ? SizedBox()
                : Container(
                    width: 130,
                    height: 55,
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(100.0),
                      color: mainSectionCTA,
                      child: MaterialButton(
                        onPressed: () => reserveBottomSheet(),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              weeklyReserveButtonText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: mainFaFontFamily,
                                  fontSize: btnSized,
                                  fontWeight: FontWeight.normal),
                            ),
                            Icon(Iconsax.receipt, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: mainFaFontFamily,
        fontSize: subTitleSize,
        color: Colors.black,
      ),
    );
  }
}
