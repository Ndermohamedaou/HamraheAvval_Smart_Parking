import 'dart:async';

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
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/settings.dart';
import 'package:connectivity/connectivity.dart';
// Related Screen
import 'package:payausers/Screens/Tabs/dashboard.dart';
import 'package:payausers/Screens/Tabs/reservedTab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Tabs/userPlate.dart';
import 'Tabs/userTraffic.dart';

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

Timer timer;
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
String email = "";
String lastLogin = "";

// Traffic List
List userTraffic = [];
int userTrafficListLen = userTraffic.length;

// Reserve View both list and length
List userReserved = [];
int userReservedListLen = userReserved.length;

String lenOfTrafic = "";
String lenOfReserve = "";
String lenOfUserPlate = "";
String locationBuilding = "";
String slotNumberInSituation = "";

// User PLates view
List userPlates = [];

// Loading Buffer
bool isLoadTraffics = false;
bool isLoadReserves = false;
//reserve Special pices
// int showPiceces = 0;
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

    isLoadTraffics = false;
    isLoadReserves = false;

    // Initialize Connection Subscription
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _pageController = PageController();
    tabBarIndex = 0;
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      READYLOCALVAR();
    });
    READYLOCALVAR();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    _pageController.dispose();
    timer.cancel();

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

  // ignore: non_constant_identifier_names
  void READYLOCALVAR() {
    getStaffInfoFromLocal().then((value) {
      setState(() {
        userId = value["userId"];
        name = value["name"];
        personalCode = value["personalCode"];
        avatar = value["avatar"];
        userSection = value["section"];
        userRole = value["role"];
        email = value["email"];
        lastLogin = value["lastLogin"];
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

    gettingMyPlates().then((plate) {
      setState(() {
        userPlates = plate;
      });
    });
  }

  Future<Map> getStaffInfoFromLocal() async {
    String readyAvatar = "";
    String readyEmail = "";
    String readyUserId = "";
    final userId = await lds.read(key: "user_id");
    final localEmail = await lds.read(key: "email");
    userToken = await lds.read(key: "token");
    final name = await lds.read(key: "name");
    final personalCode = await lds.read(key: "personal_code");
    final localAvatar = await lds.read(key: "avatar");
    String section = await lds.read(key: "section");
    String role = await lds.read(key: "role");
    String lastLogin = await lds.read(key: "lastLogin");

    try {
      Map staffInfo = await api.getStaffInfo(token: userToken);
      // Getting server info to check if they had change
      String serverAvatar = staffInfo['avatar'];
      String serverEmail = staffInfo['email'];
      String serverUserId = staffInfo["user_id"];

      // print(staffInfo);
      // Matching local Avatar with Server side
      // avatar if anythings has change it will update!
      if (localAvatar != serverAvatar) {
        setState(() {
          readyAvatar = serverAvatar;
        });
        await lds.write(key: "avatar", value: serverAvatar);
      }
      // If local if changed by HR
      if (localEmail != serverEmail) {
        setState(() {
          readyEmail = serverEmail;
        });
        await lds.write(key: "email", value: serverEmail);
      }
      // If userID for QR-code had change from API
      if (userId != serverUserId) {
        setState(() {
          readyUserId = serverUserId;
        });
        await lds.write(key: "user_id", value: serverUserId);
      }
    } catch (e) {
      // print(e);
      // IF users connection had problem, use LocalData
      readyAvatar = await lds.read(key: "avatar");
      readyEmail = await lds.read(key: "email");
      readyUserId = await lds.read(key: "user_id");
    }

    return {
      "userId": readyUserId != "" ? readyUserId : userId,
      "name": name,
      "personalCode": personalCode,
      "avatar": readyAvatar != "" ? readyAvatar : localAvatar,
      "email": readyEmail != "" ? readyEmail : email,
      "section": section,
      "role": role,
      "lastLogin": lastLogin,
    };
  }

  Future<List> getUserTrafficLogsApi(token) async {
    try {
      setState(() => isLoadTraffics = true);
      List trafficLog = await api.getUserTrafficLogs(token: token);
      return trafficLog;
    } catch (e) {
      setState(() => isLoadTraffics = false);
      return [];
    }
  }

  Future<List> getUserReservedHistory() async {
    try {
      setState(() => isLoadReserves = true);
      List reservedList = await api.userReserveHistory(token: userToken);
      // print(reservedList);
      return reservedList;
    } catch (e) {
      setState(() => isLoadReserves = false);
      print(e);
      return [];
    }
  }

  // Real View in Bottom Navigation Bar
  // and View in User Plates
  Future<List> gettingMyPlates() async {
    try {
      final plates = await api.getUserPlate(token: userToken);
      return plates;
    } catch (e) {
      print("Erorr from loading User Plates view ===> $e");
    }
  }

  // Deleting User Selected Plate
  void delUserPlate(id) async {
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
      gettingMyPlates();
    } catch (e) {
      alert(
          aType: AlertType.warning,
          title: delProcFailTitle,
          desc: delProcFailDesc);
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

  // Delete and Canceling users reseved
  void delReserve({reserveID}) async {
    try {
      String caneclingResult =
          await api.cancelingReserve(token: userToken, reservID: reserveID);
      print(caneclingResult);
      showStatusInCaseOfFlush(
          context: context,
          title: "حذف رزرو",
          msg: "حذف رزرو شما با موفقیت صورت گرفت",
          iconColor: Colors.green,
          icon: Icons.done_outline);
    } catch (e) {
      print("Error from Canceling Reserve $e");
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
            child: PageView(
              // Getting Reserve length
              onPageChanged: (pageIndex) {
                getUserReservedHistory().then((reserves) {
                  setState(() {
                    userReservedListLen = reserves.length;
                  });
                });

                // Getting Traffic length
                getUserTrafficLogsApi(userToken).then((logs) {
                  setState(() {
                    userTrafficListLen = userTraffic.length;
                  });
                });
              },
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
                  lastLogin: lastLogin,
                  userQRCode: userId != "" ? userId : "-",
                  temporarLogo: mainLogo,
                  fullnameMeme: name != "" ? name : "-",
                  userPersonalCodeMeme: personalCode != "" ? personalCode : "-",
                  avatarMeme: avatar != null ? avatar : null,
                  section: locationBuilding != "" ? locationBuilding : "-",
                  role:
                      slotNumberInSituation != "" ? slotNumberInSituation : "-",
                  userPlateNumber: plateNo != "" ? plateNo : "-",
                  userTrafficNumber:
                      userTrafficStatus != "" ? userTrafficStatus : "-",
                  userReserveNumber:
                      userReseveStatusLen != "" ? userReseveStatusLen : "-",
                ),
                UserTraffic(
                  userTrafficLog: userTraffic,
                  trafficListLen: userTrafficListLen,
                  refreshFunction: () async {
                    setState(() => userTrafficListLen = userTraffic.length);
                  },
                  filterOn10: () {
                    setState(() => userTrafficListLen = userTraffic.length);
                    userTrafficListLen > 5
                        ? setState(() => userTrafficListLen = 5)
                        : userTrafficListLen;
                    Navigator.pop(context);
                  },
                  filterOn20: () {
                    setState(() => userTrafficListLen = userTraffic.length);
                    userTrafficListLen > 20
                        ? setState(() => userTrafficListLen = 20)
                        : userTrafficListLen;
                    Navigator.pop(context);
                  },
                  filterOn50: () {
                    setState(() => userTrafficListLen = userTraffic.length);
                    userTrafficListLen > 50
                        ? setState(() => userTrafficListLen = 50)
                        : userTrafficListLen;
                    Navigator.pop(context);
                  },
                  noFilter: () {
                    setState(() => userTrafficListLen = userTraffic.length);
                    Navigator.pop(context);
                  },
                  loadingTraffics: isLoadTraffics,
                ),
                ReservedTab(
                  // reserveRefreshController: _reserveRefreshController,
                  mainThemeColor: themeChange,
                  reserves: userReserved,
                  reservListLen: userReservedListLen,
                  refreshFunction: () async {
                    setState(() => userReservedListLen = userReserved.length);
                  },
                  filterOn10: () {
                    setState(() => userReservedListLen = userReserved.length);
                    userReservedListLen > 5
                        ? setState(() => userReservedListLen = 5)
                        : userReservedListLen;
                    Navigator.pop(context);
                  },
                  filterOn20: () {
                    setState(() => userReservedListLen = userReserved.length);
                    userReservedListLen > 20
                        ? setState(() => userReservedListLen = 20)
                        : userReservedListLen;
                    Navigator.pop(context);
                  },
                  filterOn50: () {
                    setState(() => userReservedListLen = userReserved.length);
                    userReservedListLen > 50
                        ? setState(() => userReservedListLen = 50)
                        : userReservedListLen;
                    Navigator.pop(context);
                  },
                  noFilter: () {
                    setState(() => userReservedListLen = userReserved.length);
                    // print(userReserved.length);
                    Navigator.pop(context);
                  },
                  loadingReserves: isLoadReserves,
                  deletingReserve: ({reserveID}) =>
                      delReserve(reserveID: reserveID),
                ),
                UserPlates(
                  userPlates: userPlates,
                  delUserPlate: ({plateID}) => delUserPlate(plateID),
                ),
                Settings(
                  fullNameMeme: name,
                  avatarMeme: avatar != ""
                      ? avatar
                      : "https://style.anu.edu.au/_anu/4/images/placeholders/person.png",
                ),
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
