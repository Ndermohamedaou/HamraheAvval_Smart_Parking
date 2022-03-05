import 'dart:async';

import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Screens/Tabs/reserve_categories.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/instant_reserve_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/server_base_calendar_model.dart';
import 'package:payausers/providers/server_base_static_reserve_calendar_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Related Screen
import 'package:payausers/Screens/Tabs/dashboard.dart';
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
  StaffInfoModel staffInfoModel;
  ReserveWeeks reserveWeeks;
  InstantReserveModel instantReserve;
  ServerBaseCalendarModel serverBaseCalendarModel;
  ServerBaseStaticReserveCalendarModel serverBaseStaticReserveCalendarModel;

  int tabBarIndex;
  var _pageController;

  // Check internet connection
  String _connectionStatus = 'Un';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Timer _onRefreshData;

  @override
  void initState() {
    super.initState();

    _onRefreshData = Timer.periodic(Duration(seconds: 5), (Timer t) {
      // staffInfoModel.fetchStaffInfo;
      instantReserve.fetchInstantReserve;
    });

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
    _onRefreshData.cancel();
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
            iconColor: Colors.white,
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
    staffInfoModel.fetchStaffInfo;
    reserveWeeks.fetchReserveWeeks;
    instantReserve.fetchInstantReserve;
    serverBaseCalendarModel.fetchCalendar;
    serverBaseStaticReserveCalendarModel.fetchCalendar;
  }

  willPopTo() {
    /// When user tab on back button in Android phone, it will pop to previous screen.
    if (tabBarIndex >= 1 && tabBarIndex <= 4) {
      setState(() => tabBarIndex = 0);
      pageController(tabBarIndex);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Getting instance from Providers
    themeChange = Provider.of<DarkThemeProvider>(context);
    reservesModel = Provider.of<ReservesModel>(context);
    trafficsModel = Provider.of<TrafficsModel>(context);
    plateModel = Provider.of<PlatesModel>(context);
    avatarModel = Provider.of<AvatarModel>(context);
    staffInfoModel = Provider.of<StaffInfoModel>(context);
    reserveWeeks = Provider.of<ReserveWeeks>(context);
    instantReserve = Provider.of<InstantReserveModel>(context);
    serverBaseCalendarModel = Provider.of<ServerBaseCalendarModel>(context);
    serverBaseStaticReserveCalendarModel =
        Provider.of<ServerBaseStaticReserveCalendarModel>(context);

    // set Status colors
    SystemChrome.setSystemUIOverlayStyle(themeChange.darkTheme
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark);

    return WillPopScope(
        child: Scaffold(
          body: PageView(
            // Getting Reserve length
            onPageChanged: (pageIndex) async {
              if (pageIndex == 3) {
                // user_plate_notif_number
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt("user_plate_notif_number", 0);
                themeChange.userPlateNumNotif = 0;
              }

              if (pageIndex == 2) {
                // user_plate_notif_number
                SharedPreferences prefs = await SharedPreferences.getInstance();
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
                  pageController(tabBarIndex);
                },
                navigateToTrafficsTab: () {
                  setState(() => tabBarIndex = 1);
                  pageController(tabBarIndex);
                },
                navigateToReservesTab: () {
                  setState(() => tabBarIndex = 2);
                  pageController(tabBarIndex);
                },
                navigateToPlatesTab: () {
                  setState(() => tabBarIndex = 3);
                  pageController(tabBarIndex);
                },
              ),
              UserTraffic(),
              ReserveCategories(),
              UserPlates(),
              Settings(),
            ],
          ),
          // Prevent from bad background of radius in border of tabbar
          // extendBody: true,
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: themeChange.darkTheme ? darkBar : lightBar,
                selectedItemColor: mainCTA,
                unselectedItemColor:
                    HexColor(themeChange.darkTheme ? "#f9f9f9" : '#4F4D4E'),
                selectedIconTheme: IconThemeData(color: mainCTA),
                iconSize: 28,
                unselectedIconTheme: IconThemeData(size: 25),
                selectedFontSize: 14,
                unselectedFontSize: 14,
                currentIndex: tabBarIndex,
                onTap: (indexValue) {
                  setState(() => tabBarIndex = indexValue);
                  pageController(tabBarIndex);
                },
                items: [
                  BottomNavigationBarItem(
                    title: Text(dashboardText,
                        style: TextStyle(fontFamily: mainFaFontFamily)),
                    icon: Icon(Iconsax.home),
                  ),
                  BottomNavigationBarItem(
                    title: Text(
                      transactionText,
                      style: TextStyle(fontFamily: mainFaFontFamily),
                    ),
                    icon: Icon(Iconsax.car),
                  ),
                  BottomNavigationBarItem(
                    title: Container(
                      child: Text(
                        reserveText,
                        style: TextStyle(fontFamily: mainFaFontFamily),
                      ),
                    ),
                    icon: themeChange.instantUserReserve == 0
                        ? Icon(Iconsax.clipboard)
                        : Badge(
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                              '${themeChange.instantUserReserve}',
                              style: TextStyle(
                                  fontFamily: mainFaFontFamily,
                                  color: Colors.white),
                            ),
                            child: Icon(Iconsax.clipboard),
                          ),
                  ),
                  BottomNavigationBarItem(
                    title: Text(
                      myPlateText,
                      style: TextStyle(fontFamily: mainFaFontFamily),
                    ),
                    icon: themeChange.userPlateNumNotif == 0
                        ? Icon(Iconsax.book)
                        : Badge(
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                              '${themeChange.userPlateNumNotif}',
                              style: TextStyle(
                                  fontFamily: mainFaFontFamily,
                                  color: Colors.white),
                            ),
                            child: Icon(Iconsax.book)),
                  ),
                  BottomNavigationBarItem(
                    title: Text(
                      settingsText,
                      style: TextStyle(fontFamily: mainFaFontFamily),
                    ),
                    icon: Icon(Iconsax.setting_5),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => willPopTo());
  }

  void pageController(index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 1), curve: Curves.ease);
  }
}
