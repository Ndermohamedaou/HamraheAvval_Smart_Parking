// TODO: This view would change name and define very clean that mission.
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/CustomRichText.dart';
import 'package:payausers/ExtractedWidgets/filterModal.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/reserveDetailsInModal.dart';
import 'package:payausers/ExtractedWidgets/data_history.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/cancelingReserveController.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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

class _ReservedTabState extends State<ReservedTab>
    with AutomaticKeepAliveClientMixin {
  // Timer for refresh in a min, if data had any change.
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppLocalizations t = AppLocalizations.of(context);
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

    void openDetailsInModal(
        {reservID,
        reserveStatus,
        List plate,
        startTime,
        endTime,
        building,
        slot,
        int enDateTime,
        int expireTime,
        bool isShowCancelReserve}) {
      showMaterialModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(modalBottomSheetRoundedSize),
            topRight: Radius.circular(modalBottomSheetRoundedSize),
          ),
        ),
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 350),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: ReserveInDetails(
            reserveTimeExpire: expireTime,
            plate: plate,
            reserveStatusDesc: reserveStatus,
            startTime: startTime.toString(),
            endTime: endTime.toString(),
            building: building.toString(),
            slot: slot.toString(),
            themeChange: themeChange,
            isShowCancelReserve: isShowCancelReserve,
            delReserve: () {
              customAlert(
                context: context,
                alertIcon: Iconsax.receipt_2,
                borderColor: Colors.blue,
                iconColor: Colors.red,
                title: t.translate("reserves.deleteReserveTitle"),
                desc: t.translate("reserves.deleteReserveDesc"),
                acceptPressed: () {
                  cancelReserve.delReserve(
                      reserveID: reservID, context: context);
                  Navigator.pop(context);
                  // Refetch data in Providers
                  reserveWeeks.fetchReserveWeeks;
                  reservesModel.fetchReservesData;
                  reservesByWeek.fetchReserveWeeks;
                  reservesModel.fetchReservesData;
                },
                ignorePressed: () => Navigator.pop(context),
              );
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
          t.translate("reserves.reservedDays"),
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
                      return logLoadingWidgets.loading;

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
                                  DataHistory(
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
                                        expireTime: reserveList[index]
                                            ["reserveTimeStart_En"],
                                        reservID: reserveList[index]["id"],
                                        reserveStatus: reserveList[index]
                                            ['status'],
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
                                        enDateTime: reserveList[index]
                                            ["reserveTimeStart_En"],
                                        isShowCancelReserve: reserveList[index]
                                            ["isShowCancelReserve"],
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
