import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ExtractedWidgets/customClipOval.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/CustomRichText.dart';
import 'package:payausers/ExtractedWidgets/filterModal.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/miniPlate.dart';
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

    Widget traffics = Builder(builder: (_) {
      if (trafficsModel.trafficsState == FlowState.Loading)
        return logLoadingWidgets.waitCircularProgress();

      if (trafficsModel.trafficsState == FlowState.Error)
        return logLoadingWidgets.internetProblem;

      // reversed Traffics list
      final trafficsList = trafficsModel.traffics.reversed.toList();

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
                  MiniPlate(
                    plate0: trafficsList[index]["plate0"],
                    plate1: trafficsList[index]["plate1"],
                    plate2: trafficsList[index]["plate2"],
                    plate3: trafficsList[index]["plate3"],
                    buildingName: trafficsList[index]["building"] != null
                        ? trafficsList[index]["building"]
                        : "",
                    startedTime: trafficsList[index]["entry_datetime"],
                    endedTime: trafficsList[index]["exit_datetime"],
                    slotNo: trafficsList[index]["slot"],
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
                        fontWeight: FontWeight.bold,
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      trafficsLogText,
                      style: TextStyle(
                        fontFamily: mainFaFontFamily,
                        fontSize: subTitleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            traffics,
          ],
        ),
      )),
      floatingActionButton: trafficsModel.traffics.isEmpty
          ? SizedBox()
          : CustomClipOval(
              icon: Icons.filter_alt_outlined,
              firstColor: mainCTA,
              secondColor: mainSectionCTA,
              aggreementPressed: () => filterSection(),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
