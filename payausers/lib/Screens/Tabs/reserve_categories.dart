import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payausers/ExtractedWidgets/floating_button_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payausers/ExtractedWidgets/reserve_category_separator.dart';
import 'package:payausers/ExtractedWidgets/server_calendar.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/calculate_next_week.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/server_base_calendar_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/instantReserveController.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/instant_reserve_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shamsi_date/shamsi_date.dart';

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

DateTimeCalculator dateTimeCalculator = DateTimeCalculator();

Timer _onRefresh;

class _ReserveCategoriesState extends State<ReserveCategories> {
  @override
  void initState() {
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
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Reserve model for fetch and Reserve list getter
    reserveWeeks = Provider.of<ReserveWeeks>(context);
    reservesModel = Provider.of<ReservesModel>(context);
    reservesByWeek = Provider.of<ReservesByWeek>(context);
    platesModel = Provider.of<PlatesModel>(context);
    instantReserveModel = Provider.of<InstantReserveModel>(context);
    localData = Provider.of<AvatarModel>(context);
    StaffInfoModel staffInfoModel = Provider.of<StaffInfoModel>(context);
    final persianServerCalendar = Provider.of<ServerBaseCalendarModel>(context);

    // Prepared reserve list from the API
    // TODO: Fix this handy revariable after build
    Map reserves = reserveWeeks.finalReserveWeeks["reserves"] == null
        ? {}
        : reserveWeeks.finalReserveWeeks["reserves"];
    weekly = reserves["weekly"] == null ? [] : reserves["weekly"];
    list = reserves["list"] == null ? [] : reserves["list"];
    instant = reserves["instant"] == null ? [] : reserves["instant"];

    // Fetching data from server to render date of week from server calendar.
    reserveBottomSheet() {
      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        // clipBehavior: Clip.antiAlias,
        backgroundColor:
            themeChange.darkTheme ? mainBgColorDark : mainBgColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(modalBottomSheetRoundedSize),
            topRight: Radius.circular(modalBottomSheetRoundedSize),
          ),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: ServerCalendar(),
          );
        },
      );
    }

    instantReserveProcess() async {
      // Controller of Instant reserve
      InstantReserve instantReserve = InstantReserve();

      try {
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
          // Fetch for disappear of material button
          instantReserveModel.fetchInstantReserve;
          staffInfoModel.fetchStaffInfo;

          rAlert(
              context: context,
              tAlert: AlertType.success,
              title: result["message"]["title"],
              desc: result["message"]["desc"],
              onTapped: () => Navigator.popUntil(
                  context, ModalRoute.withName("/dashboard")));
        } else {
          rAlert(
              context: context,
              tAlert: AlertType.error,
              title: result["message"]["title"],
              desc: result["message"]["desc"],
              onTapped: () => Navigator.popUntil(
                  context, ModalRoute.withName("/dashboard")));
        }
      } catch (e) {
        rAlert(
            context: context,
            tAlert: AlertType.error,
            title: t.translate("global.errors.serverError"),
            desc: t.translate("global.errors.connectionFailed"),
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")));
      }
    }

    instantReserve() {
      bool checkLegalHour(int hour, int legalTime) {
        ///
        /// Check hour of Today to say user can reserve today or tomorrow?
        /// If it was true that mean reserve will be tomorrow.
        /// else reserve will be today.
        if (hour >= legalTime)
          return true;
        else
          return false;
      }

      Jalali jDateTime = Jalali.now();
      JalaliFormatter formattedDateTime = jDateTime.formatter;
      DateTime dateTimeNow = DateTime.now();

      // Preparing legal time to instant reserve.

      // checkLegalHour
      String specificDay = checkLegalHour(dateTimeNow.hour, 17)
          ? t.translate("calendarAndTime.tomorrow")
          : t.translate("calendarAndTime.today");

      String calculateDay = checkLegalHour(dateTimeNow.hour, 17)
          ? (jDateTime + 1).formatter.dd
          : formattedDateTime.dd;

      String legalDate =
          "$calculateDay/${formattedDateTime.mN}/${formattedDateTime.yyyy}";
      String instantReserveDateResult =
          "آیا مایل به رزرو لحظه ای پارکینگ برای $specificDay ساعت $legalDate می باشید؟";

      customAlert(
          context: context,
          alertIcon: Icons.access_time_outlined,
          borderColor: Colors.blue,
          iconColor: Colors.blue,
          title: t.translate("reserves.reserveCategories.instantReserve"),
          desc: instantReserveDateResult,
          acceptPressed: () {
            instantReserveProcess();
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
          title: CustomText(
              t.translate("reserves.reserveCategories.reserveCategoriesTitle")),
          actions: [
            IconButton(
              icon: Icon(
                Iconsax.information,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, "/reserveGuideView"),
            ),
          ],
          bottom: TabBar(
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: 15,
              ),
              tabs: [
                Tab(
                  icon: Icon(Iconsax.notification_bing),
                  text:
                      t.translate("reserves.reserveCategories.instantReserve"),
                ),
                Tab(
                  icon: Icon(Iconsax.calendar_tick),
                  text: t.translate("reserves.reserveCategories.weeklyReserve"),
                ),
                Tab(
                  icon: Icon(Iconsax.driver),
                  text: t.translate("reserves.reserveCategories.staticReserve"),
                ),
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            instantReserveModel.canInstantReserve == 1
                ? FloatingButtonController(
                    buttonText: t
                        .translate("reserves.reserveCategories.instantReserve"),
                    onPressed: () => instantReserve(),
                    width: 150,
                    height: 55,
                    buttonColor: importantColor,
                    buttonIcon: Iconsax.timer_start,
                  )
                : SizedBox(),
            // Checking all conditions to show or not weekly reserve button.
            reserveWeeks.reserveWeeksState == FlowState.Error ||
                    reserveWeeks.reserveWeeksState == FlowState.Loading ||
                    !reserveWeeks.finalReserveWeeks["canReserve"]
                ? SizedBox()
                : FloatingButtonController(
                    buttonText:
                        t.translate("reserves.reserveCategories.weeklyReserve"),
                    onPressed: () {
                      persianServerCalendar.fetchCalendar;
                      reserveBottomSheet();
                    },
                    width: 150,
                    height: 55,
                    buttonColor: mainSectionCTA,
                    buttonIcon: Iconsax.receipt,
                  ),
          ],
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
