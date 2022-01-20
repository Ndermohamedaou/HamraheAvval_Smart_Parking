import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ExtractedWidgets/data_history.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/CustomRichText.dart';
import 'package:payausers/ExtractedWidgets/filterModal.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/Screens/Tabs/reservedTab.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/convert_date_to_string.dart';
import 'package:payausers/controller/instentReserveController.dart';
import 'package:payausers/controller/specific_reserve_type.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/instant_reserve_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:sizer/sizer.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class WeekReservedTab extends StatefulWidget {
  const WeekReservedTab();

  @override
  _WeekReservedTabState createState() => _WeekReservedTabState();
}

int filtered = 0;
ReserveWeeks reserveWeeks;
ReservesByWeek reservesByWeek;
InstantReserveModel instantReserveModel;
AvatarModel avatarModel;
List selectedDays = [];
List selectChipList = [];
List<Widget> chipsDate = [];
List<bool> selectedDaysAsBool = [];
ConvertDate convertDate;

class _WeekReservedTabState extends State<WeekReservedTab>
    with AutomaticKeepAliveClientMixin {
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

  List<String> loadNextWeekDays = [];

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
    reserveWeeks = Provider.of<ReserveWeeks>(context);
    reservesModel = Provider.of<ReservesModel>(context);
    reservesByWeek = Provider.of<ReservesByWeek>(context);
    instantReserveModel = Provider.of<InstantReserveModel>(context);
    avatarModel = Provider.of<AvatarModel>(context);

    // Getting local data.
    final localData = Provider.of<AvatarModel>(context);
    ApiAccess api = ApiAccess(localData.userToken);
    // UI loading or Error Class
    LogLoading logLoadingWidgets = LogLoading();
    // Prepare class for getting right plate from database
    // Controller of Instant reserve
    InstantReserve instantReserve = InstantReserve();
    // Checking type of reserve.
    SpecificReserveType specificReserveType = SpecificReserveType();
    // DateTime to String name.
    convertDate = ConvertDate();

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
                        Icons.close,
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

        if (result == "200") {
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
              title: titleOfReserve,
              desc: resultOfReserve);
        } else if (result == "501")
          rAlert(
              context: context,
              onTapped: () => Navigator.pop(context),
              tAlert: AlertType.warning,
              title: "شکست در فرآیند رزرو",
              desc:
                  "شما پلاک تایید شده ای در سامانه ندارید. لطفا قبل از رزرو پلاک مورد نظر خود را وارد نمایید");
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
                                fontWeight: FontWeight.normal),
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
          await instantReserve.instantReserve(token: avatarModel.userToken);

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

    // Getting Reserve Weeks as reversed list.
    List reserveWeeksList = reserveWeeks.finalReserveWeeks.toList();

    // Calculate item count of ListView:
    final listViewItemCount = filtered == 0
        ? reserveWeeksList.length
        : reserveWeeksList.length > filtered
            ? filtered
            : reserveWeeksList.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: reserveWeeks.finalReserveWeeks.isEmpty
                ? null
                : () => filterSection(),
          ),
          IconButton(
            icon: Icon(
              Icons.info,
            ),
            onPressed: () => Navigator.pushNamed(context, "/reserveGuideView"),
          ),
        ],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.timer),
          onPressed: instantReserveModel.canInstantReserve == 1
              ? () => instantResrver()
              : null,
        ),
        title: Text(
          weekCategoriesTextTitle,
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
                    if (reserveWeeks.reserveWeeksState == FlowState.Loading)
                      return logLoadingWidgets.loading();

                    if (reserveWeeks.reserveWeeksState == FlowState.Error)
                      return logLoadingWidgets.internetProblem;

                    if (reserveWeeksList.isEmpty)
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
                                  textTwo: "از ${reserveWeeksList.length} رزرو",
                                ),
                              )
                            : SizedBox(),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: listViewItemCount,
                          itemBuilder: (BuildContext context, index) {
                            return SingleChildScrollView(
                              child: (WeekList(
                                reserveWeeksList: reserveWeeksList,
                                index: index,
                                reserveType:
                                    specificReserveType.checkReserveTypeString(
                                        reserveWeeksList[index]["type"]),
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
                Icon(Icons.add, color: Colors.white),
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

// List of every weeks.
class WeekList extends StatelessWidget {
  const WeekList(
      {@required this.reserveWeeksList,
      @required this.index,
      this.reserveType});

  final List reserveWeeksList;
  final int index;
  final String reserveType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataHisotry(
          historyBuildingName: reserveWeeksList[index]["building"] ?? "",
          reserveStatusColor: reserveWeeksList[index]["status"] ?? "",
          historySlotName: reserveWeeksList[index]["slot"] ?? "",
          historyStartTime:
              "${reserveWeeksList[index]["week"]} ${convertDate.convertDateToString(reserveWeeksList[index]["week"])}" ??
                  "",
          reserveType: reserveType,
          historyEndTime: "",
          onPressed: () {
            if (reserveWeeksList[index]["type"] == "list") {
              return null;
            } else if (reserveWeeksList[index]["type"] == "weekly") {
              reservesByWeek.setStartDate = reserveWeeksList[index]["week"];
              Navigator.pushNamed(context, "/reservedTab");
            }
          },
        ),
      ],
    );
  }
}
