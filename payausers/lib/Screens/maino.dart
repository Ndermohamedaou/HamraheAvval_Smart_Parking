import 'dart:async';

import 'package:badges/badges.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/gettingLocalData.dart';
import 'package:payausers/Model/streamAPI.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Related Screen
import 'package:payausers/Screens/Tabs/dashboard.dart';
import 'package:payausers/Screens/Tabs/reservedTab.dart';
import 'Tabs/userPlate.dart';
import 'Tabs/userTraffic.dart';

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

class _MainoState extends State<Maino> {
  // Providers
  dynamic themeChange;
  // App Providers
  ReservesModel reservesModel;
  TrafficsModel trafficsModel;
  PlatesModel plateModel;
  AvatarModel avatarModel;

  int tabBarIndex;
  var _pageController;

  ApiAccess api = ApiAccess();
  LocalDataGetterClass loadLocalData = LocalDataGetterClass();
  StreamAPI streamAPI = StreamAPI();
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
        updateProvider();
        break;
      case ConnectivityResult.mobile:
        updateProvider();
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

  // If internet connection had interrupt
  // Please update all provider even check wifi connectivity
  void updateProvider() {
    reservesModel.fetchReservesData;
    trafficsModel.fetchTrafficsData;
    plateModel.fetchPlatesData;
    avatarModel.fetchUserAvatar;
  }

  @override
  Widget build(BuildContext context) {
    // Getting instance from Providers
    themeChange = Provider.of<DarkThemeProvider>(context);
    reservesModel = Provider.of<ReservesModel>(context);
    trafficsModel = Provider.of<TrafficsModel>(context);
    plateModel = Provider.of<PlatesModel>(context);
    avatarModel = Provider.of<AvatarModel>(context);

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

                if (pageIndex == 2) {
                  // user_plate_notif_number
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt("instant_reserve_notif_number", 0);
                  themeChange.instantUserReserve = 0;
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
                ReservedTab(),
                UserPlates(),
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
              iconSize: 32,
              unselectedIconTheme: IconThemeData(size: 25),
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
                    tabBarIndex == 0
                        ? Icons.view_quilt
                        : Icons.view_quilt_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    transactionText,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: Icon(
                    tabBarIndex == 1 ? Icons.view_day : Icons.view_day_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Container(
                    child: Text(
                      reserveText,
                      style: TextStyle(fontFamily: mainFaFontFamily),
                    ),
                  ),
                  icon: themeChange.instantUserReserve == 0
                      ? Icon(
                          tabBarIndex == 2
                              ? Icons.add_business
                              : Icons.add_business_outlined,
                        )
                      : Badge(
                          animationType: BadgeAnimationType.slide,
                          badgeContent: Text(
                            '${themeChange.instantUserReserve}',
                            style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                color: Colors.white),
                          ),
                          child: Icon(
                            tabBarIndex == 2
                                ? Icons.add_business
                                : Icons.add_business_outlined,
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
                          tabBarIndex == 3
                              ? Icons.post_add
                              : Icons.post_add_sharp,
                        )
                      : Badge(
                          animationType: BadgeAnimationType.slide,
                          badgeContent: Text(
                            '${themeChange.userPlateNumNotif}',
                            style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                color: Colors.white),
                          ),
                          child: Icon(
                            tabBarIndex == 3
                                ? Icons.post_add
                                : Icons.post_add_sharp,
                          )),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    settingsText,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: Icon(
                    tabBarIndex == 4 ? Icons.settings : Icons.settings_outlined,
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
