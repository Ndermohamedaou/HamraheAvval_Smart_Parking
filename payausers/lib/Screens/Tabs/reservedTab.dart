import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/reserveDetailsInModal.dart';
import 'package:payausers/ExtractedWidgets/reserveHistoryView.dart';
import 'package:payausers/controller/reservePlatePrepare.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

PreparedPlate preparedPlate = PreparedPlate();

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
    this.loadingReserves,
    this.deletingReserve,
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
  final bool loadingReserves;
  final Function deletingReserve;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    void openDetailsInModal({
      reservID,
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
          child: SingleChildScrollView(
            child: ReserveInDetails(
              plate: plate,
              startTime: startTime,
              endTime: endTime,
              building: building,
              slot: slot,
              themeChange: themeChange,
              delReserve: () => deletingReserve(reserveID: reservID),
            ),
          ),
        ),
      );
    }

    Widget mainUserReserveHistory = ListView.builder(
      shrinkWrap: true,
      reverse: true,
      primary: false,
      itemCount: reserves != null ? reservListLen : null,
      itemBuilder: (BuildContext context, index) {
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: () => openDetailsInModal(
              reservID: reserves[index]["id"],
              plate: preparedPlate.preparePlateInReserve(
                  rawPlate: reserves[index]['plate']),
              building: reserves[index]["building"] != null
                  ? reserves[index]["building"]
                  : "",
              slot: reserves[index]["slot"],
              startTime: reserves[index]["reserveTimeStart"],
              endTime: reserves[index]["reserveTimeEnd"],
            ),
            child: (Column(
              children: [
                ReserveHistoryView(
                  historyBuildingName: reserves[index]["building"] != null
                      ? reserves[index]["building"]
                      : "",
                  reserveStatusColor: reserves[index]['status'],
                  historySlotName: reserves[index]["slot"],
                  historyStartTime: reserves[index]["reserveTimeStart"],
                  historyEndTime: reserves[index]["reserveTimeEnd"],
                ),
              ],
            )),
          ),
        );
      },
    );

    Widget notFoundReservedData = Column(
      children: [
        Image.asset(
          "assets/images/emptyBox.png",
          width: 180,
          height: 180,
        ),
        Text("شما رزروی انجام نداده اید",
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    Widget internetProblem = Column(
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

    final finalContext =
        reserves.length != 0 ? mainUserReserveHistory : notFoundReservedData;

    final reservedView = loadingReserves ? finalContext : internetProblem;

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
                          StreamBuilder(
                              // stream: ,
                              builder: (context, snapshot) {
                            return ClipOval(
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
                            );
                          }),
                        ]),
                  ),
                ),
                filterBar,
                reservedView
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
