import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/settings.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

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

int tabBarIndex = 0;
String userId = "";
String name = "";
String personalCode = "";
String avatar = "";
String userToken = "";
String userSection = "";
String userRole = "";
List userTraffic = [];
String lenOfTrafic = "";
String lenOfReserve = "";
String lenOfUserPlate = "";

ApiAccess api = ApiAccess();

var _pageController = PageController();

class _MainoState extends State<Maino> {
  FlutterSecureStorage lds = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 10), (timer) {
      READYLOCALVAR();
    });
    READYLOCALVAR();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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
      // Coreponding
      if (localAvatar != serverAvatar) {
        setState(() async {
          readyAvatar = serverAvatar;
        });
        await lds.write(key: "avatar", value: serverAvatar);
      }
    } catch (e) {
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

  Future<Map> getLenUserPlates() async {
    List userPlateList = await api.getUserPlate(token: userToken);
    // Traffic Logs
    List userTrafficLeng = await api.getUserTrafficLogs(token: userToken);

    final lenUserPlate = userPlateList.length.toString();
    final lenUserTrafficNo = userTrafficLeng.length.toString();

    return {"platesNum": lenUserPlate, "userTrafficNum": lenUserTrafficNo};
  }

  @override
  Widget build(BuildContext context) {
    //  Dark Theme Changer
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // set Status colors
    SystemChrome.setSystemUIOverlayStyle(themeChange.darkTheme
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark);

    // Number of user plate
    final plateNo = lenOfUserPlate != "" ? lenOfUserPlate : emptyPlateNumber;
    // Number of Users traffics
    final userTrafficStatus =
        lenOfTrafic != "" ? lenOfTrafic : emptyPlateNumber;

    final String userReseveStatusLen = emptyPlateNumber;

    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Dashboard(
                userQRCode: userId,
                fullnameMeme: name,
                userPersonalCodeMeme: personalCode,
                avatarMeme: avatar,
                section: userSection,
                role: userRole,
                userPlateNumber: plateNo,
                userTrafficNumber: userTrafficStatus,
                userReserveNumber: userReseveStatusLen,
              ),
              UserTraffic(
                userTrafficLog: userTraffic,
              ),
              ReservedTab(
                mainThemeColor: themeChange,
              ),
              AddUserPlate(),
              Settings(fullNameMeme: name, avatarMeme: avatar)
            ],
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
                print(tabBarIndex);
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
      onWillPop: () async => false,
    );
  }
}
