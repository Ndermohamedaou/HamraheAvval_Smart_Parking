import 'dart:async';

import 'package:badges/badges.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/gettingLocalData.dart';
import 'package:payausers/controller/streamAPI.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/settings.dart';
import 'package:connectivity/connectivity.dart';
// Related Screen
import 'package:payausers/Screens/Tabs/dashboard.dart';
import 'package:payausers/Screens/Tabs/reservedTab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Tabs/userPlate.dart';
import 'Tabs/userTraffic.dart';

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

dynamic themeChange;
int tabBarIndex;
var _pageController;

//reserve Special pices
// int showPiceces = 0;
ApiAccess api = ApiAccess();
LocalDataGetterClass loadLocalData = LocalDataGetterClass();
StreamAPI streamAPI = StreamAPI();

class _MainoState extends State<Maino> {
  FlutterSecureStorage lds = FlutterSecureStorage();
  // Check internet connection
  String _connectionStatus = 'Un';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    // Initialize Connection Subscription
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _pageController = PageController();
    tabBarIndex = 0;

    loadLocalData.getStaffInfoFromLocal();
    loadLocalData.getUserInfoInReal();
    streamAPI.getUserTrafficsReal();
    streamAPI.getUserReserveReal();
    streamAPI.getUserPlatesReal();

    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    _pageController.dispose();

    initConnectivity();
    // Close init
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Checker Function internet connection
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        break;
      case ConnectivityResult.mobile:
        break;
      case ConnectivityResult.none:
        showStatusInCaseOfFlush(
            context: context,
            title: connectionFailedTitle,
            msg: connectionFailed,
            iconColor: Colors.blue,
            icon: Icons.wifi_off_rounded);
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  //TODO: Change and movie this in controller
  // Deleting User Selected Plate
  void delUserPlate(id) async {
    print(id);
    try {
      final userToken = await lds.read(key: "token");
      final delStatus = await api.delUserPlate(token: userToken, id: id);
      if (delStatus == "200") {
        alert(
            context: context,
            aType: AlertType.success,
            title: delProcSucTitle,
            desc: delProcDesc,
            themeChange: themeChange,
            dstRoute: "dashboard");
      }
      // gettingMyPlates(); when u use stream for user plates show don't need that
    } catch (e) {
      alert(
          aType: AlertType.warning,
          title: delProcFailTitle,
          desc: delProcFailDesc);
    }
  }

  // Delete and Canceling users reseved
  void delReserve({reserveID}) async {
    final userToken = await lds.read(key: "token");
    try {
      String caneclingResult =
          await api.cancelingReserve(token: userToken, reservID: reserveID);
      if (caneclingResult == "200") {
        Navigator.pop(context);
        showStatusInCaseOfFlush(
            context: context,
            title: "لغو رزرو",
            msg: "لغو رزرو شما با موفقیت صورت گرفت",
            iconColor: Colors.green,
            icon: Icons.done_outline);
      } else if (caneclingResult == "500") {
        Navigator.pop(context);
        showStatusInCaseOfFlush(
            context: context,
            title: "حذف رزرو",
            msg: "این رزرو یک بار لغو شده است",
            iconColor: Colors.orange,
            icon: Icons.warning);
      }
    } catch (e) {
      showStatusInCaseOfFlush(
          context: context,
          title: "حذف رزرو",
          msg: "حذف رزرو شما با مشکلی مواجه شده است، لطفا بعدا امتحان کنید",
          iconColor: Colors.red,
          icon: Icons.close);
      print("Error from Canceling Reserve $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    // set Status colors
    SystemChrome.setSystemUIOverlayStyle(themeChange.darkTheme
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark);

    return WillPopScope(
        child: Scaffold(
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(
                'برای خروج دوبار روی بازگشت کلیک کنید',
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            child: PageView(
              // Getting Reserve length
              onPageChanged: (pageIndex) async {
                if (pageIndex == 3) {
                  // user_plate_notif_number
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt("user_plate_notif_number", 0);
                  themeChange.userPlateNumNotif = 0;
                }
              },
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Dashboard(
                  openUserDashSettings: () {
                    setState(() => tabBarIndex = 4);
                    _pageController.animateToPage(4,
                        duration: Duration(milliseconds: 1),
                        curve: Curves.easeOut);
                  },
                ),
                UserTraffic(),
                ReservedTab(
                  deletingReserve: ({reserveID}) =>
                      delReserve(reserveID: reserveID),
                ),
                UserPlates(
                  delUserPlate: ({plateID}) => delUserPlate(plateID),
                ),
                Settings(),
              ],
            ),
          ),
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.rtl,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: themeChange.darkTheme ? darkBar : lightBar,
              selectedItemColor: mainSectionCTA,
              unselectedItemColor: HexColor('#C9C9C9'),
              selectedIconTheme: IconThemeData(color: mainSectionCTA),
              iconSize: 25,
              // unselectedIconTheme: IconThemeData(size: 25),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              currentIndex: tabBarIndex,
              onTap: (indexValue) {
                setState(() => tabBarIndex = indexValue);
                pageControllerFunc(tabBarIndex);
              },
              items: [
                BottomNavigationBarItem(
                  title: Text(
                    dashboardText,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: Icon(
                    Icons.view_quilt,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    transactionText,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: Icon(
                    Icons.view_day,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Container(
                    child: Text(
                      reserveText,
                      style: TextStyle(fontFamily: mainFaFontFamily),
                    ),
                  ),
                  icon: CircleAvatar(
                    backgroundColor: mainSectionCTA,
                    radius: 25,
                    child: Icon(
                      Icons.add_business_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    myPlateText,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: themeChange.userPlateNumNotif == 0
                      ? Icon(
                          Icons.post_add_sharp,
                        )
                      : Badge(
                          animationType: BadgeAnimationType.slide,
                          badgeContent: Text(
                            '${themeChange.userPlateNumNotif}',
                            style: TextStyle(fontFamily: mainFaFontFamily),
                          ),
                          child: Icon(Icons.post_add_sharp),
                        ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    settingsText,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: Icon(
                    Icons.settings,
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () =>
            SystemChannels.platform.invokeMethod('SystemNavigator.pop')
        // exit(0),
        );
  }

  void pageControllerFunc(index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 1), curve: Curves.ease);
  }
}
