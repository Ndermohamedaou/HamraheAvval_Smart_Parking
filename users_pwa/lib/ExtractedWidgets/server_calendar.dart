import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/Custom_material_button_controller.dart';
import 'package:payausers/ExtractedWidgets/custom_text_controller.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/navigation_button_controller.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/calculate_next_week.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/server_calendar_controller.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/server_base_calendar_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

class ServerCalendar extends StatefulWidget {
  const ServerCalendar({Key key}) : super(key: key);

  @override
  _ServerCalendarState createState() => _ServerCalendarState();
}

class _ServerCalendarState extends State<ServerCalendar> {
  String loadEvent = "";
  int index = 1;
  // Define a controller for CarouselSlider when user click on next or previous button
  CarouselController _carouselController = CarouselController();
  // Create list of reserver, by default would be selected reserve from the server
  List selectedReserveList = [];

  @override
  Widget build(BuildContext context) {
    final localData = Provider.of<AvatarModel>(context);
    final reserveWeeks = Provider.of<ReserveWeeks>(context);
    final reservesModel = Provider.of<ReservesModel>(context);
    final reservesByWeek = Provider.of<ReservesByWeek>(context);

    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Calculated width size of device for avoid from bad overflow.
    Size size = MediaQuery.of(context).size;
    final double gridContainerResponsibilityWidth =
        size.width > 500 ? 500 : 320;

    final persianServerCalendar = Provider.of<ServerBaseCalendarModel>(context);

    // TODO: Init data if it exists on previous list, change this line to have global widget
    LogLoading logLoadingWidgets = LogLoading();
    ServerCalendarController calendarController = ServerCalendarController();

    List staticWeekDay = [sat, sun, mon, tues, wed, thurs, fri];
    // Getting current server month
    final serverMonths = persianServerCalendar.calendar["months"];
    selectedReserveList = persianServerCalendar.calendar["reserved_days"];

    // Helper function for classify and separate data together
    dynamic dayBgColor(bool isClickable, bool isHoliday, String dateFa,
        String date, bool isSelected) {
      // Check List of selected reserve to have selected this day (simulate on toggle click)
      if (selectedReserveList.contains(date)) return mainCTA;

      if (isHoliday) return holidayBgColor;

      if (dateFa == fri || dateFa == thurs) return Colors.grey.shade300;

      return Colors.transparent;
    }

    dynamic dayBorderColor(bool isClickable) {
      if (isClickable) return mainCTA;

      return Colors.transparent;
    }

    dynamic dayTextColor(bool isClickable, bool isHoliday, String date,
        String dateFa, bool isSelected) {
      // Simulate on toggle click
      if (selectedReserveList.contains(date)) return Colors.white;
      if (isClickable) return null;

      if (dateFa == fri || dateFa == thurs) return Colors.black;

      if (isHoliday) return Colors.white;
    }

    // Simulate onToggle click
    onDateClick(
        {String eventDesc, bool isClickable, String date, bool isSelected}) {
      ///
      /// Checking data to prepare proper behavior.
      if (eventDesc != "") {
        showStatusInCaseOfFlush(
          context: context,
          mainBackgroundColor: "#F38137",
          title: holidayTitle,
          msg: holidayDesc,
          iconColor: Colors.white,
          icon: Icons.close,
        );
      }
      setState(() => loadEvent = eventDesc);

      if (!selectedReserveList.contains(date)) {
        // Checking if day is clickable to select that
        isClickable ? selectedReserveList.add(date) : null;
        // Prevent from duplicate data on selected reserve list.
        setState(
            () => selectedReserveList = selectedReserveList.toSet().toList());
      } else {
        // Checking if day is clickable to select that
        isClickable ? selectedReserveList.remove(date) : null;
        // Prevent from duplicate data on selected reserve list.
        setState(
            () => selectedReserveList = selectedReserveList.toSet().toList());
      }

      // print(selectedReserveList);
    }

    // TODO: Convert this to callback function
    onSubmitReserve() async {
      ApiAccess api = ApiAccess(localData.userToken);
      DateTimeCalculator dateTimeCalculator = DateTimeCalculator();
      final dates =
          dateTimeCalculator.parseDatesFromNextWeek(selectedReserveList);

      Endpoint weeklyReserveEndpoint =
          apiEndpointsMap["reserveEndpoint"]["doWeeklyReserve"];

      try {
        final weeklyReserveResult = await api.requestHandler(
            weeklyReserveEndpoint.route,
            weeklyReserveEndpoint.method,
            {"dates": dates});

        // Fetching all data from the server
        reservesModel.fetchReservesData;
        reserveWeeks.fetchReserveWeeks;
        reservesByWeek.fetchReserveWeeks;

        if (weeklyReserveResult["status"] == "success")
          rAlert(
              context: context,
              tAlert: AlertType.success,
              title: weeklyReserveResult["message"]["title"],
              desc: weeklyReserveResult["message"]["desc"],
              onTapped: () => Navigator.popUntil(
                  context, ModalRoute.withName("/dashboard")));

        if (weeklyReserveResult["status"] == "failed")
          rAlert(
              context: context,
              tAlert: AlertType.warning,
              title: weeklyReserveResult["message"]["title"],
              desc: weeklyReserveResult["message"]["desc"],
              onTapped: () => Navigator.popUntil(
                  context, ModalRoute.withName("/dashboard")));

        if (weeklyReserveResult["status"] == "warning")
          rAlert(
              context: context,
              tAlert: AlertType.error,
              title: weeklyReserveResult["message"]["title"],
              desc: weeklyReserveResult["message"]["desc"],
              onTapped: () => Navigator.popUntil(
                  context, ModalRoute.withName("/dashboard")));
      } catch (e) {
        print(e);
        rAlert(
            context: context,
            tAlert: AlertType.error,
            title: serverCatchErrorTitle,
            desc: serverCatchErrorDesc,
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")));
      }
    }

    return Column(
      children: [
        SizedBox(height: 1.0.h),
        Container(
          width: 50,
          height: 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavigationButton(
              themeChange: themeChange,
              icon: Icons.arrow_back_ios,
              onClick: () {
                _carouselController.nextPage();
                index >= 0 && index <= 1
                    ? setState(() => index++)
                    : setState(() => index = 2);
              },
            ),
            CustomTextController(
              text: "${serverMonths[index]}",
              fontSize: 25,
            ),
            NavigationButton(
              themeChange: themeChange,
              icon: Icons.arrow_forward_ios,
              onClick: () {
                _carouselController.previousPage();
                index > 0 && index <= 2
                    ? setState(() => index--)
                    : setState(() => index = 0);
              },
            ),
          ],
        ),
        Builder(
          builder: (_) {
            if (persianServerCalendar.calendarState == FlowState.Loading)
              return logLoadingWidgets.loading;

            if (persianServerCalendar.calendarState == FlowState.Error)
              return logLoadingWidgets.internetProblem;

            return Container(
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: calendarController
                    .calculateCalendar(persianServerCalendar.calendar)
                    .length,
                itemBuilder:
                    (BuildContext context, int sliderIndex, int pageViewIndex) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 20, top: 0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: [
                          // Rendering day week name
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20),
                            width: gridContainerResponsibilityWidth,
                            child: GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              semanticChildCount: 7,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: 7,
                              itemBuilder:
                                  (BuildContext context, int weekIndex) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: CustomTextController(
                                    text: staticWeekDay[weekIndex][0],
                                    textColor: Colors.grey.shade600,
                                    fontSize: 18,
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20),
                            width: gridContainerResponsibilityWidth,
                            child: GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: calendarController
                                  .calculateCalendar(persianServerCalendar
                                      .calendar)[sliderIndex]
                                  .length,
                              itemBuilder: (context, index) {
                                // Getting week data reader
                                final week = calendarController
                                    .calculateCalendar(persianServerCalendar
                                        .calendar)[sliderIndex];
                                return GestureDetector(
                                  onTap: () {
                                    onDateClick(
                                        eventDesc: week[index]["event_desc"],
                                        isClickable: week[index]["clickable"],
                                        date: week[index]["date"],
                                        isSelected: week[index]["isSelected"]);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: dayBgColor(
                                            week[index]["clickable"],
                                            week[index]["holiday"],
                                            week[index]["date_fa"],
                                            week[index]["date"],
                                            week[index]["isSelected"]),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                            color: dayBorderColor(
                                                week[index]["clickable"]),
                                            width: 2)),
                                    child: CustomTextController(
                                      text: week[index]["day"],
                                      textColor: dayTextColor(
                                          week[index]["clickable"],
                                          week[index]["holiday"],
                                          week[index]["date"],
                                          week[index]["date_fa"],
                                          week[index]["isSelected"]),
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  disableCenter: true,
                  autoPlay: false,
                  initialPage: 1,
                  enlargeCenterPage: true,
                  reverse: true,
                  enableInfiniteScroll: false,
                  aspectRatio: 1.1,
                  viewportFraction: 1,
                  height: 380,
                  onPageChanged:
                      (int onChange, CarouselPageChangedReason reason) {
                    setState(() => index = onChange);
                  },
                ),
              ),
            );
          },
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 20),
          child: CustomTextController(
            text: loadEvent == "" ? "" : "مناسبت ها",
            fontSize: 22,
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 20),
          child: CustomTextController(
            text: loadEvent,
            fontSize: 20,
            textAlign: TextAlign.right,
            textColor: Colors.red,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.rtl,
          children: [
            CustomMaterialButtonController(
              buttonText: submitTextForAlert,
              buttonColor: mainSectionCTA,
              buttonTextColor: Colors.white,
              onClick: () => onSubmitReserve(),
            ),
            CustomMaterialButtonController(
              buttonText: closeALayer,
              buttonTextColor: mainSectionCTA,
              buttonColor: themeChange.darkTheme ? darkBar : Colors.white,
              onClick: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        // SizedBox(height: 1.0.h),
      ],
    );
  }
}
