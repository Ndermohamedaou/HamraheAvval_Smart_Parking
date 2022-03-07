import 'package:flutter/material.dart';
import 'package:payausers/ExtractedWidgets/Custom_rich_text.dart';
import 'package:payausers/ExtractedWidgets/data_history.dart';
import 'package:payausers/ExtractedWidgets/log_loading.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/Model/static_reserve_info.dart';
import 'package:payausers/controller/convert_date_to_string.dart';
import 'package:payausers/controller/specific_reserve_type.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/server_base_static_reserve_calendar_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';

class ReserveCategorySeparator extends StatefulWidget {
  // To having reserveWeeks provider model to handling error and other things
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
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    // Access to api from the local Storage user token
    StaffInfoModel staffInfoModel = Provider.of<StaffInfoModel>(context);

    // Date conversion.
    convertDate = ConvertDate();
    // UI loading or Error Class
    LogLoading logLoadingWidgets = LogLoading();
    // Checking type of reserve.
    SpecificReserveType specificReserveType = SpecificReserveType(context);

    ServerBaseStaticReserveCalendarModel serverBaseStaticReserveCalendarModel =
        Provider.of<ServerBaseStaticReserveCalendarModel>(context);

    final categoryName =
        specificReserveType.checkReserveTypeString(widget.reserveTypeName);

    // Calculate item count of ListView:
    final listViewItemCount = filtered == 0
        ? widget.reserveListByType.length
        : widget.reserveListByType.length > filtered
            ? filtered
            : widget.reserveListByType.length;

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
                        FlowState.Loading) return logLoadingWidgets.loading;

                    if (widget.reserveWeeks.reserveWeeksState ==
                        FlowState.Error)
                      return logLoadingWidgets.internetProblem;

                    if (widget.reserveListByType.isEmpty)
                      return logLoadingWidgets.notFoundReservedData(
                          msg: staffInfoModel.staffInfo["parking_type"] == 1
                              ? "رزرو $categoryName"
                              : t.translate(
                                      "global.info.organizationParkingUsed") +
                                  " شما رزروی");

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
                              child: DataHistory(
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
                                datePrefix: widget.reserveListByType[index]
                                    ["type"],
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
                                    serverBaseStaticReserveCalendarModel
                                        .fetchCalendar;
                                    StaticReserveInfo staticReserveInfo =
                                        StaticReserveInfo(
                                      staticReserveId:
                                          widget.reserveListByType[index]["id"],
                                      reserveStatus: widget
                                          .reserveListByType[index]["status"],
                                      slotNumber: widget
                                          .reserveListByType[index]["slot"],
                                      buildingName: widget
                                          .reserveListByType[index]["building"],
                                      cancelDays:
                                          widget.reserveListByType[index]
                                              ["cancelDays"],
                                    );
                                    // Send info to next view
                                    Navigator.pushNamed(
                                        context, "/staticReserveView",
                                        arguments: staticReserveInfo);
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
