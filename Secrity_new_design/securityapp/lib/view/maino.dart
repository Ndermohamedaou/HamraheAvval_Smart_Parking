import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/localDataController.dart';
import 'package:securityapp/controller/slotController.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/shrinkMenuBuilder.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sizer/sizer.dart';

String token = "";
String fullname = "";
// LocalStorage Controller Class
LoadingLocalData LLDs = LoadingLocalData();

// Slot Viewer
SlotsViewer slotView = SlotsViewer();
Map slotsMap = {};

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

class _MainoState extends State<Maino> {
  @override
  void initState() {
    LLDs.gettingStaffInfoInLocal().then((local) {
      setState(() {
        token = local["token"];
        fullname = local["fullname"];
      });
    });

    slotView.gettingSlots().then((slots) => setState(() {
          slotsMap = slots;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    print(slotsMap);

    final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

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
            fullname: fullname,
            changeTheme: (bool val) {
              themeChange.darkTheme = val;
            }),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
