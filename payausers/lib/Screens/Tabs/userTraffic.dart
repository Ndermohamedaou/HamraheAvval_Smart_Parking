import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ExtractedWidgets/custom_divider.dart';
import 'package:payausers/ExtractedWidgets/custom_sub_title.dart';
import 'package:payausers/ExtractedWidgets/custom_title.dart';
import 'package:payausers/ExtractedWidgets/data_history.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/CustomRichText.dart';
import 'package:payausers/ExtractedWidgets/filterModal.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserTraffic extends StatefulWidget {
  const UserTraffic();

  @override
  _UserTrafficState createState() => _UserTrafficState();
}

int filtered = 0;
TrafficsModel trafficsModel;
Timer _onRefreshTrafficsPerMin;

class _UserTrafficState extends State<UserTraffic>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    _onRefreshTrafficsPerMin = Timer.periodic(Duration(minutes: 1), (timer) {
      trafficsModel.fetchTrafficsData;
    });
    super.initState();
  }

  @override
  void dispose() {
    _onRefreshTrafficsPerMin.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Providers
    final themeChange = Provider.of<DarkThemeProvider>(context);
    trafficsModel = Provider.of<TrafficsModel>(context);

    // UI loading or Error Class
    LogLoading logLoadingWidgets = LogLoading();

    openTrafficInfoInBottomActionSheet(
        {List plate, String startTime, String endTime}) {
      /// Show user plate + start time and end time
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 1.0.h),
                Container(
                  width: 30,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                ),
                PlateViewer(
                  plate0: plate[0],
                  plate1: plate[1],
                  plate2: plate[2],
                  plate3: plate[3],
                  themeChange: themeChange.darkTheme,
                ),
                SizedBox(height: 2.0.h),
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTitle(
                        textTitle: entranceDateReserve, fw: FontWeight.normal),
                    CustomSubTitle(textTitle: startTime),
                  ],
                ),
                CustomDivider(),
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTitle(
                        textTitle: exitDateReserve, fw: FontWeight.normal),
                    CustomSubTitle(textTitle: endTime),
                  ],
                ),
                SizedBox(height: 2.0.h),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                SizedBox(height: 1.0.h),
              ],
            ),
          ),
        ),
      );
    }

    Widget traffics = Builder(builder: (_) {
      if (trafficsModel.trafficsState == FlowState.Loading)
        return logLoadingWidgets.loading();

      if (trafficsModel.trafficsState == FlowState.Error)
        return logLoadingWidgets.internetProblem;

      // reversed Traffics list
      final trafficsList = trafficsModel.traffics.reversed.toList();

      // Loading Traffic Widget.
      if (trafficsList.isEmpty)
        return logLoadingWidgets.notFoundReservedData(msg: "تردد");
      return Column(
        children: [
          filtered != 0
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: CustomRichText(
                    themeChange: themeChange,
                    textOne: "نمایش $filtered ",
                    textTwo: "از ${trafficsList.length} تردد",
                  ),
                )
              : SizedBox(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: filtered == 0
                ? trafficsList.length
                : trafficsList.length > filtered
                    ? filtered
                    : trafficsList.length,
            primary: false,
            itemBuilder: (BuildContext context, index) {
              return (Column(
                children: [
                  DataHisotry(
                    reserveStatusColor: null,
                    historyBuildingName: trafficsList[index]["building"] ?? "",
                    historySlotName: trafficsList[index]["slot"] ?? "",
                    historyStartTime:
                        trafficsList[index]["entry_datetime"] ?? "",
                    historyEndTime: trafficsList[index]["exit_datetime"] ?? "",
                    onPressed: () => openTrafficInfoInBottomActionSheet(
                      plate: [
                        trafficsList[index]["plate0"],
                        trafficsList[index]["plate1"],
                        trafficsList[index]["plate2"],
                        trafficsList[index]["plate3"]
                      ],
                      startTime:
                          trafficsList[index]["entry_datetime"] ?? dateWasNull,
                      endTime:
                          trafficsList[index]["exit_datetime"] ?? dateWasNull,
                    ),
                  ),
                ],
              ));
            },
          ),
        ],
      );
    });

    void filterSection() {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        // backgroundColor: ,
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
                        fontWeight: FontWeight.normal,
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
                text: "نمایش 5 تردد",
                filterPressed: () {
                  setState(() => filtered = 5);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۲۰ تردد",
                filterPressed: () {
                  setState(() => filtered = 20);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۵۰ تردد",
                filterPressed: () {
                  setState(() => filtered = 50);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش تمام تردد",
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
        automaticallyImplyLeading: false,
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.filter),
            onPressed:
                trafficsModel.traffics.isEmpty ? null : () => filterSection(),
          ),
        ],
        centerTitle: true,
        title: Text(
          trafficsLogText,
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
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              traffics,
            ],
          ),
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
