import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/localDataController.dart';
import 'package:securityapp/controller/slotController.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/alert.dart';
import 'package:securityapp/widgets/shrinkMenuBuilder.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sizer/sizer.dart';

String token = "";
String fullname = "";
String avatar = "";
// LocalStorage Controller Class
LoadingLocalData llds = LoadingLocalData();

// Slot Viewer
SlotsViewer slotView = SlotsViewer();
Map slotsMap = {};

// Set for getting data
Timer timer;

class Util {
  Map getColorByStatus({status: int}) {
    switch (status) {
      case 0:
        return {"color": empty, "string": "خالی"};

      case 1:
        return {"color": fullSlot, "string": "پر"};

      default:
        return {"color": reserve, "string": "رزرو"};
    }
  }
}

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

class _MainoState extends State<Maino> {
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 60), (timer) => findContent());
    findContent();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Section for finding content function
  void findContent() {
    // Getting data from Secure storage
    llds.gettingStaffInfoInLocal().then((local) {
      setState(() {
        token = local["token"];
        fullname = local["fullname"];
        avatar = local["avatar"];
      });
    });
    // getting tiles of slot grid
    slotView.gettingSlots().then((slots) => setState(() {
          slotsMap = slots;
        }));
  }

  void openSlotDetails({status: Map, slotNum}) {
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: true,
      bounce: true,
      duration: const Duration(milliseconds: 550),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Column(
          children: [
            SizedBox(height: 10.0.h),
            CustomText(
              text: slotTitleInBottomAction,
              size: 25.0.sp,
              fw: FontWeight.w500,
              align: TextAlign.center,
            ),
            CustomText(
              text: slotNum,
              size: 20.0.sp,
              align: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                CustomText(
                  text: slotStatusString,
                  size: 18.0.sp,
                  align: TextAlign.center,
                ),
                SizedBox(width: 10),
                CustomText(
                  text: status["string"],
                  size: 18.0.sp,
                  color: status["color"],
                  align: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 10.0.h)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
    Util indicatorUtil = new Util();

    final gridContext = slotsMap.isEmpty
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 100),
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: slotsMap['floors'] != null
                  ? slotsMap['floors'].length - 1
                  : 0,
              itemBuilder: (BuildContext context, int item) => Column(
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: CustomText(
                          text: "${slotsMap["floors"][item]} طبقه ",
                          size: 16.0.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.0.h),
                  GridView.builder(
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: slotsMap["${slotsMap['floors'][item]}"] != null
                        ? slotsMap["${slotsMap['floors'][item]}"].length - 1
                        : 0,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) => Container(
                      decoration: BoxDecoration(
                          color: indicatorUtil.getColorByStatus(
                              status: slotsMap["${slotsMap['floors'][item]}"]
                                  [index]["status"])["color"],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                          )),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => openSlotDetails(
                              slotNum: slotsMap["${slotsMap['floors'][item]}"]
                                  [index]["id"],
                              status: indicatorUtil.getColorByStatus(
                                  status:
                                      slotsMap["${slotsMap['floors'][item]}"]
                                          [index]["status"])),
                          child: CustomText(
                            size: 13.0.sp,
                            // slotsMap["${slotsMap['floors'][item]}"][index]["id"]
                            text:
                                "P ${slotsMap["${slotsMap['floors'][item]}"][index]["id"]}",
                            color: slotsMap["${slotsMap['floors'][item]}"]
                                        [index]["status"] ==
                                    1
                                ? Colors.white
                                : slotsMap["${slotsMap['floors'][item]}"][index]
                                            ["status"] ==
                                        -1
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
                ],
              ),
            ),
          );

    final slotsContainer = slotsMap.isNotEmpty
        ? gridContext
        : Column(
            children: [
              Lottie.asset("assets/animation/buildings.json"),
              CustomText(
                text: "در حال دریافت اطلاعات",
              ),
            ],
          );

    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: SideMenu(
        key: _sideMenuKey,
        inverse: true,
        background: themeChange.darkTheme ? sideColorDark : sideColorLight,
        closeIcon: Icon(Icons.close,
            color: themeChange.darkTheme ? Colors.white : Colors.black),
        type: SideMenuType.slideNRotate,
        menu: buildMenu(
          themeChange: themeChange,
          context: context,
          // Will Change from api in lds + avatar
          avatar: avatar,
          fullname: fullname,
        ),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: appBarColor,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/hamrahLogoAppBar.png",
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  final _state = _sideMenuKey.currentState;
                  if (_state.isOpened)
                    _state.closeSideMenu();
                  else
                    _state.openSideMenu();
                },
              ),
            ],
            title: CustomText(
              text: securityAppBarText,
              fw: FontWeight.bold,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 4.0.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.0.w),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        CustomText(
                          text: slotsTitleText,
                          size: 15.0.sp,
                          fw: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.0.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: slotsContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
