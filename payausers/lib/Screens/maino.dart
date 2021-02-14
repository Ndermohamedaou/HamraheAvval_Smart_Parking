import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/settings.dart';
import 'package:connectivity/connectivity.dart';
// Related Screen
import 'package:payausers/Screens/Tabs/dashboard.dart';
import 'package:payausers/Screens/Tabs/reservedTab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Tabs/addUserPlate.dart';
import 'Tabs/userTraffic.dart';

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

dynamic themeChange;
int tabBarIndex;
var _pageController;
String userId = "";
String name = "";
String personalCode = "";
String avatar = "";
String userToken = "";
String userSection = "";
String userRole = "";
List userTraffic = [];
List userReserved = [];
String lenOfTrafic = "";
String lenOfReserve = "";
String lenOfUserPlate = "";
String locationBuilding = "";
String slotNumberInSituation = "";

ApiAccess api = ApiAccess();

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
    Timer.periodic(Duration(seconds: 10), (timer) {
      READYLOCALVAR();
    });
    READYLOCALVAR();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
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

  void READYLOCALVAR() {
    getStaffInfoFromLocal().then((value) {
      setState(() {
        userId = value["userId"];
        name = value["name"];
        personalCode = value["personalCode"];
        avatar = value["avatar"];
        userSection = value["section"];
        userRole = value["role"];
      });
      getUserTrafficLogsApi(userToken).then((logs) {
        setState(() {
          // print(logs);
          userTraffic = logs;
        });
      });
      getLenUserPlates().then((userLens) {
        setState(() {
          lenOfUserPlate = userLens["platesNum"];
          lenOfTrafic = userLens["userTrafficNum"];
        });
      });
      getUserReservedHistory().then((reserves) {
        setState(() {
          userReserved = reserves;
          lenOfReserve = reserves.length.toString();
        });
      });
      getUserCarSituation().then((situation) {
        locationBuilding = situation["locationBuilding"];
        slotNumberInSituation = situation["slotNo"];
      });
    });
  }

  Future<Map> getStaffInfoFromLocal() async {
    String readyAvatar = "";
    final userId = await lds.read(key: "user_id");
    userToken = await lds.read(key: "token");
    final name = await lds.read(key: "name");
    final personalCode = await lds.read(key: "personal_code");
    final localAvatar = await lds.read(key: "avatar");
    String section = await lds.read(key: "section");
    String role = await lds.read(key: "role");

    try {
      String serverAvatar = await api.getUserAvatar(token: userToken);
      // Correspondence local Avatar with Server side avatar
      if (localAvatar != serverAvatar) {
        setState(() async {
          readyAvatar = serverAvatar;
        });
        await lds.write(key: "avatar", value: serverAvatar);
      }
    } catch (e) {
      print(e);
      readyAvatar = await lds.read(key: "avatar");
    }

    return {
      "userId": userId,
      "name": name,
      "personalCode": personalCode,
      "avatar": readyAvatar != "" ? readyAvatar : localAvatar,
      "section": section,
      "role": role
    };
  }

  Future<List> getUserTrafficLogsApi(token) async {
    List trafficLog = await api.getUserTrafficLogs(token: token);
    return trafficLog;
  }

  Future<List> getUserReservedHistory() async {
    try {
      List reservedList = await api.userReserveHistory(token: userToken);
      // print(reservedList);
      return reservedList;
    } catch (e) {
      // print(e);
      return [];
    }
  }

  Future<Map> getLenUserPlates() async {
    List userPlateList = await api.getUserPlate(token: userToken);
    // Traffic Logs
    List userTrafficLeng = await api.getUserTrafficLogs(token: userToken);

    final lenUserPlate = userPlateList.length.toString();
    final lenUserTrafficNo = userTrafficLeng.length.toString();

    return {"platesNum": lenUserPlate, "userTrafficNum": lenUserTrafficNo};
  }

  // User car plate situation function
  Future<Map> getUserCarSituation() async {
    Map staffSitu;
    try {
      staffSitu = await api.getStaffInfo(token: userToken);
      // User Car Plate situation
      return {
        "locationBuilding": staffSitu["location"]["building"],
        "slotNo": staffSitu["location"]["slot"],
      };
    } catch (e) {
      staffSitu = await api.getStaffInfo(token: userToken);
      return {"locationBuilding": staffSitu["location"], "slotNo": ""};
    }
  }

  @override
  Widget build(BuildContext context) {
    //  Dark Theme Changer
    themeChange = Provider.of<DarkThemeProvider>(context);
    // set Status colors
    SystemChrome.setSystemUIOverlayStyle(themeChange.darkTheme
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark);

    // Number of user plate
    final plateNo = lenOfUserPlate != "" ? lenOfUserPlate : emptyPlateNumber;
    // Number of Users traffics
    final userTrafficStatus =
        lenOfTrafic != "" ? lenOfTrafic : emptyPlateNumber;

    final String userReseveStatusLen =
        lenOfReserve != "" ? lenOfReserve : emptyPlateNumber;

    final String mainImgLogoLightMode =
        "assets/images/Titile_Logo_Mark_light.png";
    final String mainImgLogoDarkMode =
        "assets/images/Titile_Logo_Mark_dark.png";
    final String mainLogo =
        themeChange.darkTheme ? mainImgLogoDarkMode : mainImgLogoLightMode;

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
            child: SafeArea(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Dashboard(
                    openUserDashSettings: () {
                      setState(() {
                        tabBarIndex = 4;
                      });
                      _pageController.animateToPage(4,
                          duration: Duration(milliseconds: 1),
                          curve: Curves.easeOut);
                    },
                    userQRCode: userId != "" ? userId : "-",
                    temporarLogo: mainLogo,
                    fullnameMeme: name != "" ? name : "-",
                    userPersonalCodeMeme:
                        personalCode != "" ? personalCode : "-",
                    avatarMeme: avatar != null ? avatar : null,
                    section: locationBuilding != "" ? locationBuilding : "-",
                    role: slotNumberInSituation != ""
                        ? slotNumberInSituation
                        : "-",
                    userPlateNumber: plateNo != "" ? plateNo : "-",
                    userTrafficNumber:
                        userTrafficStatus != "" ? userTrafficStatus : "-",
                    userReserveNumber:
                        userReseveStatusLen != "" ? userReseveStatusLen : "-",
                  ),
                  UserTraffic(
                    userTrafficLog: userTraffic,
                  ),
                  ReservedTab(
                    mainThemeColor: themeChange,
                    reserves: userReserved,
                  ),
                  AddUserPlate(),
                  Settings(
                    fullNameMeme: name,
                    avatarMeme: avatar != ""
                        ? avatar
                        : "https://style.anu.edu.au/_anu/4/images/placeholders/person.png",
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.rtl,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: themeChange.darkTheme ? darkBar : lightBar,
              selectedItemColor: Colors.blue,
              unselectedItemColor: HexColor('#C9C9C9'),
              selectedIconTheme: IconThemeData(color: Colors.blue),
              iconSize: 25,
              // unselectedIconTheme: IconThemeData(size: 25),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              currentIndex: tabBarIndex,
              onTap: (indexValue) {
                setState(() {
                  tabBarIndex = indexValue;
                  _pageController.animateToPage(tabBarIndex,
                      duration: Duration(milliseconds: 3), curve: Curves.ease);
                  // print(tabBarIndex);
                });
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
                    backgroundColor: loginBtnColor,
                    radius: 25,
                    child: Icon(
                      Icons.add_business_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    "افزودن پلاک",
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: Icon(
                    Icons.post_add_sharp,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text(
                    settingsText,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  icon: Icon(
                    Icons.account_circle,
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
}
