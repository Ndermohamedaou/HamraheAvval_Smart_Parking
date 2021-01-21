import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/settings.dart';
// Related Screen
import 'package:payausers/Screens/Tabs/dashboard.dart';
import 'package:payausers/Screens/Tabs/reservedTab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

int tabBarIndex = 0;
String userId = "";
String name = "";
String personalCode = "";
String avatar = "";

var _pageController = PageController();

class _MainoState extends State<Maino> {
  FlutterSecureStorage lds = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getStaffInfoFromLocal().then((value) {
      setState(() {
        userId = value["userId"];
        name = value["name"];
        personalCode = value["personalCode"];
        avatar = value["avatar"];
      });
    });
  }

  Future<Map> getStaffInfoFromLocal() async {
    final userId = await lds.read(key: "user_id");
    final name = await lds.read(key: "name");
    final personalCode = await lds.read(key: "personal_code");
    final avatar = await lds.read(key: "avatar");
    return {
      "userId": userId,
      "name": name,
      "personalCode": personalCode,
      "avatar": avatar
    };
  }

  @override
  Widget build(BuildContext context) {
    //  Dark Theme Changer
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // set Status colors
    SystemChrome.setSystemUIOverlayStyle(themeChange.darkTheme
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark);

    return Scaffold(
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
            ),
            Container(child: Text("ترددها")),
            ReservedTab(
              mainThemeColor: themeChange,
            ),
            Container(child: Text("افزودن پلاک")),
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
    );
  }
}


