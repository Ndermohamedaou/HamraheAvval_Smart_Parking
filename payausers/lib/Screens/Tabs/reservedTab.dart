import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/CustomRichText.dart';
import 'package:payausers/ExtractedWidgets/filterModal.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/reserveDetailsInModal.dart';
import 'package:payausers/ExtractedWidgets/data_history.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/cancelingReserveController.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
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
// Only for getting list of currently reserved.
ReservesModel reservesModel;
// To having reserves list of specific week.
ReservesByWeek reservesByWeek;
// To having reserves of weeks.
ReserveWeeks reserveWeeks;

List selectedDays = [];
List<Widget> chipsDate = [];
List<bool> selectedDaysAsBool = [];

class _ReservedTabState extends State<ReservedTab>
    with AutomaticKeepAliveClientMixin {
  // Timer for refresh in a min, if data had any change.
  @override
  void initState() {
    getAWeek();
    super.initState();
  }

  @override
  void dispose() {
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
    for (var i = 0; i < 5; i++) {
      final date = firstOfTheWeek + i;
      // Create zero before date;
      final correctMonth = date.month < 10 ? '0${date.month}' : date.month;
      final correctDate = date.day < 10 ? '0${date.day}' : date.day;

      selectedDays.add({
        "value": "${date.year}-$correctMonth-$correctDate",
        "label":
            "${date.formatter.wN} ${date.formatter.d.toPersianDigit()} ${date.formatter.mN} ${date.formatter.yyyy.toPersianDigit()}"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Reserve model for fetch and Reserve list getter
    reservesModel = Provider.of<ReservesModel>(context);
    reservesByWeek = Provider.of<ReservesByWeek>(context);
    reserveWeeks = Provider.of<ReserveWeeks>(context);
    // To getting local data.
    final localData = Provider.of<AvatarModel>(context);
    ApiAccess api = ApiAccess(localData.userToken);

    // UI loading or Error Class
    LogLoading logLoadingWidgets = LogLoading();
    // Prepare class for getting right plate from database
    // PreparedPlate preparedPlate = PreparedPlate();
    // Controller of Instant reserve
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
            startTime: startTime.toString(),
            endTime: endTime.toString(),
            building: building.toString(),
            slot: slot.toString(),
            themeChange: themeChange,
            delReserve: () {
              cancelReserve.delReserve(reserveID: reservID, context: context);
              // Refetch data in Providers
              reserveWeeks.fetchReserveWeeks;
              reservesModel.fetchReservesData;
              reservesByWeek.fetchReserveWeeks;
              reservesModel.fetchReservesData;
            },
          ),
        ),
      );
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
                  Text(
                    "فیلتر نتایج",
                    style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      fontSize: 25.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Iconsax.close_circle,
                        size: 29,
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

    // Reserve by select chips
    reserveByChips(String date) async {
      Endpoint reserveEndpoint =
          apiEndpointsMap["reserveEndpoint"]["changeDailyReserveStatus"];

      try {
        final result = await api.requestHandler(
            "${reserveEndpoint.route}?date=$date", reserveEndpoint.method, {});

        print(result);
        if (result == "200") {
          // If reserve was successful, then update reserves model for getting
          // New week date list.
          reservesModel.fetchReservesData;
          // Update own data of reserves.
          reservesByWeek.fetchReserveWeeks;

          Navigator.pop(context);
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.success,
              title: titleOfReserve,
              desc: resultOfReserve);
        } else if (result == "501")
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.warning,
              title: "شکست در فرآیند رزرو",
              desc:
                  "شما پلاک تایید شده ای در سامانه ندارید. لطفا قبل از رزرو، پلاک مورد نظر خود را وارد نمایید");
        else
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.warning,
              title: titleOfFailedReserve,
              desc: descOfFailedReserve);
      } catch (e) {
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
            builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
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
                                  fontSize: 25.0)),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.filter),
            onPressed:
                reservesModel.reserves.isEmpty ? null : () => filterSection(),
          ),
          IconButton(
            icon: Icon(
              Iconsax.information,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/reserveGuideView");
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          reserveTextTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Builder(
                  builder: (_) {
                    if (reservesByWeek.reservesByWeekState == FlowState.Loading)
                      return logLoadingWidgets.loading();

                    if (reservesByWeek.reservesByWeekState == FlowState.Error)
                      return logLoadingWidgets.internetProblem;

                    List reserveList =
                        reservesByWeek.reservesList.reversed.toList();

                    if (reserveList.isEmpty)
                      return logLoadingWidgets.notFoundReservedData(
                          msg: "رزرو");

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
                              child: (Column(
                                children: [
                                  DataHisotry(
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
                                    onPressed: () {
                                      // Update user reserves in provider
                                      reservesModel.fetchReservesData;
                                      openDetailsInModal(
                                        reservID: reserveList[index]["id"],
                                        reserveStatus: reserveList[index]
                                            ['status'],
                                        // plate: preparedPlate.preparePlateInReserve(
                                        //     rawPlate: reserveList[index]['plate']),
                                        plate: [],
                                        building: reserveList[index]
                                                    ["building"] !=
                                                null
                                            ? reserveList[index]["building"]
                                            : "",
                                        slot: reserveList[index]["slot"],
                                        startTime: reserveList[index]
                                            ["reserveTimeStart"],
                                        endTime: reserveList[index]
                                            ["reserveTimeEnd"],
                                      );
                                    },
                                  ),
                                ],
                              )),
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
      floatingActionButton: Container(
        width: 170,
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
                  "افزودن رزرو جدید",
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
