import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/CustomRichText.dart';
import 'package:payausers/ExtractedWidgets/data_history.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/static_reserve_in_details.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/convert_date_to_string.dart';
import 'package:payausers/controller/specific_reserve_type.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReserveCategorySeparator extends StatefulWidget {
  // To having reserveWeeks provider modle to handling error and other things
  final ReserveWeeks reserveWeeks;
  // Provide setter for navigating to new page of weekly reserver
  final ReservesByWeek reservesByWeek;
  // Only having list of one category
  final List reserveListByType;
  // To have category name
  final String reserveTypeName;

  const ReserveCategorySeparator({
    this.reserveWeeks,
    this.reservesByWeek,
    this.reserveListByType,
    this.reserveTypeName,
  });

  @override
  ReserveCategorySeparatorState createState() =>
      ReserveCategorySeparatorState();
}

int filtered = 0;
ConvertDate convertDate;
String listReserveId = "";

class ReserveCategorySeparatorState extends State<ReserveCategorySeparator> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    PersianDatePickerWidget persianDatePicker;
    final TextEditingController textEditingController = TextEditingController();
    final localData = Provider.of<AvatarModel>(context);
    // Access to api from the local storaged user token
    ApiAccess api = ApiAccess(localData.userToken);

    // Date conversion.
    convertDate = ConvertDate();
    // UI loading or Error Class
    LogLoading logLoadingWidgets = LogLoading();
    // Checking type of reserve.
    SpecificReserveType specificReserveType = SpecificReserveType();

    final categoryName =
        specificReserveType.checkReserveTypeString(widget.reserveTypeName);

    // Calculate item count of ListView:
    final listViewItemCount = filtered == 0
        ? widget.reserveListByType.length
        : widget.reserveListByType.length > filtered
            ? filtered
            : widget.reserveListByType.length;

    void openCalendar() {
      // Focus on the Calendar
      FocusScope.of(context).requestFocus(new FocusNode());

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return persianDatePicker;
        },
      );
    }

    void openDetailsInModal(
        {String staticReserveId,
        String slot,
        String building,
        int status,
        String type,
        List cancelDays}) {
      // Fill Static reserve id to delete day from calendar
      setState(() => listReserveId = staticReserveId);

      // Show Modal Bottom Sheet
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: StaticReserveInDetails(
            slot: slot,
            building: building,
            cancelDays: cancelDays,
            reserveStatusDesc: status,
            openCalendar: () => openCalendar(),
          ),
        ),
      );
    }

    twicePop() {
      int count = 0;
      // Back to home page or maino dashboard view
      // with popUntill twice back in application
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    }

    // Delete a day from user reserve
    deleteStaticReserve({List cancelList}) async {
      /// We Pass on [date] to api
      ///
      /// Getting response from the api to handling flush content
      String status = "";

      Endpoint cancelListReserve =
          apiEndpointsMap["reserveEndpoint"]["cancelListReserve"];

      final result = await api
          .requestHandler(cancelListReserve.route, cancelListReserve.method, {
        "id": listReserveId,
        "dates": cancelList,
      });

      // Update data from the Provider
      widget.reservesByWeek.fetchReserveWeeks;
      widget.reserveWeeks.fetchReserveWeeks;

      // Parsing data from the response
      status = result["status"];

      if (status == "success") {
        Navigator.pop(context);
        twicePop();
        rAlert(
            context: context,
            onTapped: () => Navigator.pop(context),
            tAlert: AlertType.success,
            title: result["message"]["title"],
            desc: result["message"]["desc"]);
      }

      if (status == "failed") {
        Navigator.pop(context);
        twicePop();
        rAlert(
            context: context,
            onTapped: () => Navigator.pop(context),
            tAlert: AlertType.warning,
            title: result["message"]["title"],
            desc: result["message"]["desc"]);
      }

      if (status == "warning") {
        Navigator.pop(context);
        twicePop();
        rAlert(
            context: context,
            onTapped: () => Navigator.pop(context),
            tAlert: AlertType.error,
            title: result["message"]["title"],
            desc: result["message"]["desc"]);
      }
    }

    // TODO: Change this in proper time
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      headerTextStyle: TextStyle(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
          fontSize: 18),
      // Today setup
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
        customAlert(
          context: context,
          alertIcon: Icons.delete,
          iconColor: Colors.red,
          title: listConfirmTitle,
          desc: listConfirmDesc,
          acceptPressed: () {
            deleteStaticReserve(cancelList: [newDate]);
          },
          ignorePressed: () => Navigator.pop(context),
        );
      },
    ).init();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Builder(
                  builder: (_) {
                    if (widget.reserveWeeks.reserveWeeksState ==
                        FlowState.Loading) return logLoadingWidgets.loading();

                    if (widget.reserveWeeks.reserveWeeksState ==
                        FlowState.Error)
                      return logLoadingWidgets.internetProblem;

                    if (widget.reserveListByType.isEmpty)
                      return logLoadingWidgets.notFoundReservedData(
                          msg: "رزرو $categoryName");

                    return Column(
                      children: [
                        filtered != 0
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerRight,
                                child: CustomRichText(
                                  themeChange: themeChange,
                                  textOne: "نمایش $filtered ",
                                  textTwo:
                                      "از ${widget.reserveListByType.length} رزرو",
                                ),
                              )
                            : SizedBox(),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: listViewItemCount,
                          itemBuilder: (BuildContext context, index) {
                            return SingleChildScrollView(
                              child: DataHisotry(
                                historyBuildingName: widget
                                        .reserveListByType[index]["building"] ??
                                    "",
                                reserveStatusColor:
                                    widget.reserveListByType[index]["status"] ??
                                        "",
                                historySlotName: widget.reserveListByType[index]
                                        ["slot"] ??
                                    "",
                                historyStartTime:
                                    widget.reserveListByType[index]
                                        ["first_enter_day"],
                                historyEndTime: "",
                                reserveType:
                                    specificReserveType.checkReserveTypeString(
                                        widget.reserveListByType[index]
                                            ["type"]),
                                onPressed: () {
                                  if (widget.reserveListByType[index]["type"] ==
                                      "weekly") {
                                    widget.reservesByWeek.reservesList = [];
                                    widget.reservesByWeek
                                            .stateReservesByWeekState =
                                        FlowState.Loading;
                                    widget.reservesByWeek.setStartDate =
                                        widget.reserveListByType[index]["week"];
                                    Navigator.pushNamed(
                                        context, "/reservedTab");
                                  }

                                  if (widget.reserveListByType[index]["type"] ==
                                      "list") {
                                    openDetailsInModal(
                                        staticReserveId: widget
                                            .reserveListByType[index]["id"],
                                        slot: widget.reserveListByType[index]
                                            ["slot"],
                                        building:
                                            widget.reserveListByType[index]
                                                ["building"],
                                        status: widget.reserveListByType[index]
                                            ["status"],
                                        type: widget.reserveListByType[index]
                                            ["type"],
                                        cancelDays:
                                            widget.reserveListByType[index]
                                                    ["cancelDays"] ??
                                                []);
                                  }
                                },
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
      ),
    );
  }
}
