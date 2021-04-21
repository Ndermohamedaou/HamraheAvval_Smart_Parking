import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/miniPlate.dart';
import 'package:sizer/sizer.dart';

class UserTraffic extends StatelessWidget {
  const UserTraffic({
    this.userTrafficLog,
    this.trafficListLen,
    this.filterOn10,
    this.filterOn20,
    this.filterOn50,
    this.noFilter,
    this.refreshFunction,
    this.loadingTraffics,
  });

  final List userTrafficLog;
  final int trafficListLen;
  final Function filterOn10;
  final Function filterOn20;
  final Function filterOn50;
  final Function noFilter;
  final refreshFunction;
  final bool loadingTraffics;

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    Widget traffics = Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: trafficListLen,
          primary: false,
          itemBuilder: (BuildContext context, index) {
            return (Column(
              children: [
                MiniPlate(
                  plate0: userTrafficLog[index]["plate0"],
                  plate1: userTrafficLog[index]["plate1"],
                  plate2: userTrafficLog[index]["plate2"],
                  plate3: userTrafficLog[index]["plate3"],
                  buildingName: userTrafficLog[index]["building"] != null
                      ? userTrafficLog[index]["building"]
                      : "",
                  startedTime: userTrafficLog[index]["entry_datetime"],
                  endedTime: userTrafficLog[index]["exit_datetime"],
                  slotNo: userTrafficLog[index]["slot"],
                ),
              ],
            ));
          },
        ),
      ],
    );

    Widget searchingProcess = Column(
      children: [
        Image.asset(
          "assets/images/emptyBox.png",
          width: 180,
          height: 180,
        ),
        Text("شما ترددی ندارید",
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    Widget notFoundTrafficData = Column(
      children: [
        Lottie.asset(
          "assets/lottie/notFoundTraffics.json",
          width: 180,
          height: 180,
        ),
        Text("عدم برقراری ارتباط با سرویس دهنده",
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    final plateContext =
        userTrafficLog.length == 0 ? searchingProcess : traffics;

    final trafficView = loadingTraffics ? plateContext : notFoundTrafficData;

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
                text: "نمایش 5 رزور",
                filterPressed: filterOn10,
              ),
              FilterMenu(
                text: "نمایش ۲۰ رزرو",
                filterPressed: filterOn20,
              ),
              FilterMenu(
                text: "نمایش ۵۰ رزرو",
                filterPressed: filterOn50,
              ),
              FilterMenu(
                text: "نمایش تمام رزروها",
                filterPressed: noFilter,
              ),
              SizedBox(height: 2.0.h),
            ],
          ),
        ),
      );
    }

    final filterBar = userTrafficLog.length != 0
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "نمایش $trafficListLen تردد",
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontFamily: mainFaFontFamily,
                          fontSize: subTitleSize,
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
            ),
          )
        : SizedBox();

    return Scaffold(
      body: SafeArea(
          child: LiquidPullToRefresh(
        onRefresh: refreshFunction,
        showChildOpacityTransition: false,
        backgroundColor: Colors.white,
        color: mainCTA,
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
              filterBar,
              trafficView,
            ],
          ),
        ),
      )),
      floatingActionButton: userTrafficLog.length != 0
          ? ClipOval(
              child: Material(
                color: mainCTA, // button color
                child: InkWell(
                  splashColor: mainSectionCTA, // inkwell color
                  child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.white,
                      )),
                  onTap: () => filterSection(),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}

class FilterMenu extends StatelessWidget {
  const FilterMenu({
    this.text,
    this.filterPressed,
  });

  final String text;
  final Function filterPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: filterPressed,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 14.0.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
