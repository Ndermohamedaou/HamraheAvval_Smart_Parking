import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/Custom_material_button_controller.dart';
import 'package:payausers/ExtractedWidgets/custom_text_controller.dart';
import 'package:payausers/ExtractedWidgets/log_loading.dart';
import 'package:payausers/ExtractedWidgets/navigation_button_controller.dart';
import 'package:payausers/ExtractedWidgets/static_reserve_in_details.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/Model/reserve_colors_status.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/Model/static_reserve_info.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/flushbar_status.dart';
import 'package:payausers/controller/server_calendar_controller.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/server_base_static_reserve_calendar_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

class StaticReserveView extends StatefulWidget {
  const StaticReserveView({Key key}) : super(key: key);

  @override
  _StaticReserveViewState createState() => _StaticReserveViewState();
}

class _StaticReserveViewState extends State<StaticReserveView> {
  String loadEvent = "";
  int index = 1;
  // Define a controller for CarouselSlider when user click on next or previous button
  CarouselController _carouselController = CarouselController();
  // Create list of reserver, by default would be selected reserve from the server
  List selectedReserveList = [];
  List newSelectedDays = [];

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final localData = Provider.of<AvatarModel>(context);
    final reserveWeeks = Provider.of<ReserveWeeks>(context);
    final reservesByWeek = Provider.of<ReservesByWeek>(context);

    // Arguments from the previous page
    StaticReserveInfo staticReserveInfo =
        ModalRoute.of(context).settings.arguments;

    // Calculated width size of device for avoid from bad overflow.
    Size size = MediaQuery.of(context).size;
    final double gridContainerResponsibilityWidth =
        size.width > 500 ? 500 : double.infinity;

    ServerBaseStaticReserveCalendarModel serverBaseStaticReserveCalendarModel =
        Provider.of<ServerBaseStaticReserveCalendarModel>(context);

    LogLoading logLoadingWidgets = LogLoading();
    ServerCalendarController calendarController = ServerCalendarController();

    List staticWeekDay = [
      t.translate("calendarAndTime.week.sat"),
      t.translate("calendarAndTime.week.sun"),
      t.translate("calendarAndTime.week.mon"),
      t.translate("calendarAndTime.week.tues"),
      t.translate("calendarAndTime.week.wed"),
      t.translate("calendarAndTime.week.thurs"),
      t.translate("calendarAndTime.week.fri")
    ];
    // Getting current server month
    final serverMonths =
        serverBaseStaticReserveCalendarModel.staticReserveCalendar["months"];
    selectedReserveList = serverBaseStaticReserveCalendarModel
        .staticReserveCalendar["reserved_days"];

    // Helper function for classify and separate data together
    dynamic dayBgColor(bool isClickable, bool isHoliday, String dateFa,
        String date, bool isSelected) {
      // Check List of selected reserve to have selected this day (simulate on toggle click)
      if (selectedReserveList.contains(date)) return mainSectionCTA;

      if (isHoliday) return holidayBgColor;

      if (dateFa == t.translate("calendarAndTime.week.fri") ||
          dateFa == t.translate("calendarAndTime.week.thurs"))
        return Colors.grey.shade300;

      return Colors.transparent;
    }

    dynamic dayBorderColor(bool isClickable) {
      if (isClickable) return mainSectionCTA;

      return Colors.transparent;
    }

    dynamic dayTextColor(bool isClickable, bool isHoliday, String date,
        String dateFa, bool isSelected) {
      // Simulate on toggle click
      if (selectedReserveList.contains(date)) return Colors.white;
      if (isClickable) return null;

      if (dateFa == t.translate("calendarAndTime.week.fri") ||
          dateFa == t.translate("calendarAndTime.week.thurs"))
        return Colors.black;

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
          title: t.translate("global.info.holidaySelectTitle"),
          msg: t.translate("global.info.holidaySelectDesc"),
          iconColor: Colors.white,
          icon: Icons.close,
        );
      }
      setState(() => loadEvent = eventDesc);

      if (!selectedReserveList.contains(date)) {
        // Checking if day is clickable to select that
        isClickable ? selectedReserveList.add(date) : null;
        isClickable ? newSelectedDays.add(date) : null;
        // Prevent from duplicate data on selected reserve list.
        setState(() {
          selectedReserveList = selectedReserveList.toSet().toList();
          newSelectedDays = newSelectedDays.toSet().toList();
        });
      } else {
        // Checking if day is clickable to select that
        isClickable ? selectedReserveList.remove(date) : null;
        isClickable ? newSelectedDays.remove(date) : null;
        // Prevent from duplicate data on selected reserve list.
        setState(() {
          selectedReserveList = selectedReserveList.toSet().toList();
          newSelectedDays = newSelectedDays.toSet().toList();
        });
      }
    }

    showCancelReserveList() {
      // Show Modal Bottom Sheet
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(modalBottomSheetRoundedSize),
            topRight: Radius.circular(modalBottomSheetRoundedSize),
          ),
        ),
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: StaticReserveInDetails(
            cancelDays: serverBaseStaticReserveCalendarModel
                .staticReserveCalendar["reserved_days"],
          ),
        ),
      );
    }

    // Delete a day from user reserve
    deleteStaticReserve({List cancelList}) async {
      /// We Pass on [date] to api
      ///
      /// Getting response from the api to handling flush content
      String status = "";
      ApiAccess api = ApiAccess(localData.userToken);
      // print(staticReserveInfo.staticReserveId);
      // print(cancelList);

      Endpoint cancelListReserve =
          apiEndpointsMap["reserveEndpoint"]["cancelListReserve"];

      try {
        final result = await api
            .requestHandler(cancelListReserve.route, cancelListReserve.method, {
          "id": staticReserveInfo.staticReserveId,
          "dates": cancelList,
        });

        // Update data from the Provider
        reservesByWeek.fetchReserveWeeks;
        reserveWeeks.fetchReserveWeeks;
        serverBaseStaticReserveCalendarModel.fetchCalendar;

        // Backed to middle of calendar.
        index = 1;
        // newSelectedDays will empty to prevent from duplicating date selection.
        setState(() => newSelectedDays = []);

        // Parsing data from the response
        status = result["status"];

        if (status == "success") {
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.success,
              title: result["message"]["title"],
              desc: result["message"]["desc"]);
        }

        if (status == "failed") {
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.warning,
              title: result["message"]["title"],
              desc: result["message"]["desc"]);
        }

        if (status == "warning") {
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.error,
              title: result["message"]["title"],
              desc: result["message"]["desc"]);
        }
      } catch (e) {
        rAlert(
            context: context,
            tAlert: AlertType.error,
            title: t.translate("global.errors.serverError"),
            desc: t.translate("global.errors.connectionError"),
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          "رزرو ثابت",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.0.h),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTitle(textTitle: "نتیجه رزرو", fw: FontWeight.normal),
                  CustomSubTitle(
                      textTitle: ReserveStatusSpecification(context)
                          .getReserveStatusString(
                              staticReserveInfo.reserveStatus),
                      color: ReserveStatusSpecification(context)
                          .getReserveStatusColor(
                              staticReserveInfo.reserveStatus)),
                ],
              ),
              SizedBox(height: 2.0.h),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTitle(textTitle: "جایگاه", fw: FontWeight.normal),
                  CustomSubTitle(textTitle: staticReserveInfo.slotNumber),
                ],
              ),
              SizedBox(height: 2.0.h),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTitle(textTitle: "ساختمان", fw: FontWeight.normal),
                  CustomSubTitle(textTitle: staticReserveInfo.buildingName),
                ],
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? darkBar : lightBar,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.centerRight,
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "لیست روزهای لغو شده",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    ),
                    CustomMaterialButtonController(
                      buttonText: "مشاهده",
                      buttonColor: mainSectionCTA,
                      buttonTextColor: Colors.white,
                      onClick: () => showCancelReserveList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? darkBar : lightBar,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  t.translate("calendarAndTime.cancelReserve"),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NavigationButton(
                    themeChange: themeChange,
                    icon: Iconsax.arrow_left_2,
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
                    icon: Iconsax.arrow_right_3,
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
                  if (serverBaseStaticReserveCalendarModel.calendarState ==
                      FlowState.Loading) return logLoadingWidgets.loading;

                  if (serverBaseStaticReserveCalendarModel.calendarState ==
                      FlowState.Error) return logLoadingWidgets.internetProblem;

                  return Container(
                    child: CarouselSlider.builder(
                      carouselController: _carouselController,
                      itemCount: calendarController
                          .calculateCalendar(
                              serverBaseStaticReserveCalendarModel
                                  .staticReserveCalendar,
                              context)
                          .length,
                      itemBuilder: (BuildContext context, int sliderIndex,
                          int pageViewIndex) {
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: calendarController
                                        .calculateCalendar(
                                            serverBaseStaticReserveCalendarModel
                                                .staticReserveCalendar,
                                            context)[sliderIndex]
                                        .length,
                                    itemBuilder: (context, index) {
                                      // Getting week data reader
                                      final week =
                                          calendarController.calculateCalendar(
                                              serverBaseStaticReserveCalendarModel
                                                  .staticReserveCalendar,
                                              context)[sliderIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          onDateClick(
                                              eventDesc: week[index]
                                                  ["event_desc"],
                                              isClickable: week[index]
                                                  ["clickable"],
                                              date: week[index]["date"],
                                              isSelected: week[index]
                                                  ["isSelected"]);
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
                                              borderRadius:
                                                  BorderRadius.circular(18),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: TextDirection.rtl,
        children: [
          CustomMaterialButtonController(
              buttonText: t.translate("global.actions.confirm"),
              buttonColor: mainSectionCTA,
              buttonTextColor: Colors.white,
              onClick: () {
                final cancelDays = newSelectedDays.map((day) => day).toString();
                final cancelDaysArray = cancelDays == "()" ? "" : cancelDays;

                cancelDays == "()"
                    ? rAlert(
                        context: context,
                        tAlert: AlertType.error,
                        title:
                            t.translate("calendarAndTime.emptyCancelDaysTitle"),
                        desc:
                            t.translate("calendarAndTime.emptyCancelDaysDesc"),
                        onTapped: () => Navigator.pop(context))
                    : customAlert(
                        context: context,
                        alertIcon: Iconsax.box_remove,
                        iconColor: Colors.red,
                        title: t.translate(
                            "calendarAndTime.cancelDaysConfirmTitle"),
                        desc: t.translate(
                                "calendarAndTime.cancelDaysConfirmDesc") +
                            "\n" +
                            cancelDaysArray,
                        acceptPressed: () {
                          deleteStaticReserve(cancelList: newSelectedDays);
                          Navigator.pop(context);
                        },
                        ignorePressed: () => Navigator.pop(context),
                      );
              }),
          CustomMaterialButtonController(
            buttonText: t.translate("global.actions.close"),
            buttonTextColor: mainSectionCTA,
            buttonColor: themeChange.darkTheme ? darkBar : Colors.white,
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    this.textTitle,
    this.fw,
  });
  final textTitle;
  final fw;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: mainFaFontFamily, fontSize: 20.0, fontWeight: fw),
          ),
        ],
      ),
    );
  }
}

class CustomSubTitle extends StatelessWidget {
  const CustomSubTitle({this.textTitle, this.color});
  final textTitle;
  final color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: color,
              fontFamily: mainFaFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
