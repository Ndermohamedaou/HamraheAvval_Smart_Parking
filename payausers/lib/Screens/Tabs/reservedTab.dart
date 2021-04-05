import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/miniReserveHistory.dart';
import 'package:sizer/sizer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

AlphabetList alp = AlphabetList();

class ReservedTab extends StatelessWidget {
  const ReservedTab({
    this.mainThemeColor,
    this.reserves,
    this.reservListLen,
    this.filterOn10,
    this.filterOn20,
    this.filterOn50,
    this.noFilter,
    this.reserveRefreshController,
    this.refreshFunction,
  });

  final mainThemeColor;
  final List reserves;
  final int reservListLen;
  final Function filterOn10;
  final Function filterOn20;
  final Function filterOn50;
  final Function noFilter;
  final reserveRefreshController;
  final refreshFunction;

  @override
  Widget build(BuildContext context) {
    // Change Lottie Background with dark/light theme
    var notThere = mainThemeColor.darkTheme
        ? "assets/lottie/reserve_dark.json"
        : "assets/lottie/reserve_light.json";

    Widget emptyListManagerShower = Column(
      children: [
        Center(
            child: Container(
                margin: EdgeInsets.all(50),
                width: 250,
                height: 250,
                child: Lottie.asset(notThere))),
        Text(choseTime,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    Widget mainUserReserveHistory = ListView.builder(
      shrinkWrap: true,
      reverse: true,
      primary: false,
      itemCount: reserves != null ? reservListLen : null,
      itemBuilder: (BuildContext context, index) {
        List perment = reserves[index]['plate'].split("-");
        return SingleChildScrollView(
          child: (Column(
            children: [
              MiniReserveHistory(
                plate0: "${perment[0]}",
                plate1: "${alp.getAlp()[perment[1]]}",
                plate2: "${perment[2].substring(0, 3)}",
                plate3: "${perment[2].substring(3, 5)}",
                status: reserves[index]['status'],
                buildingName: reserves[index]["building"] != null
                    ? reserves[index]["building"]
                    : "",
                startedTime: reserves[index]["reserveTimeStart"],
                endedTime: reserves[index]["reserveTimeEnd"],
                slotNo: reserves[index]["slot"],
              ),
            ],
          )),
        );
      },
    );

    final finalContext =
        reserves.length != 0 ? mainUserReserveHistory : emptyListManagerShower;

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

    final filterBar = reserves.length != 0
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "نمایش $reservListLen رزرو",
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
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            reserveTextTitle,
                            style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                fontSize: subTitleSize,
                                fontWeight: FontWeight.bold),
                          ),
                          ClipOval(
                            child: Material(
                              color: mainCTA, // button color
                              child: InkWell(
                                splashColor: mainSectionCTA, // inkwell color
                                child: SizedBox(
                                    width: 46,
                                    height: 46,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    )),
                                onTap: () => Navigator.pushNamed(
                                    context, "/reserveEditaion"),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                filterBar,
                finalContext
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: reserves.length != 0
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
        ));
  }
}
