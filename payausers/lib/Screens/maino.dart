import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Screens/Tabs/dashboard.dart';

class Maino extends StatefulWidget {
  @override
  _MainoState createState() => _MainoState();
}

int tabBarIndex = 0;

var _pageController = PageController();

class _MainoState extends State<Maino> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(themeChange.darkTheme
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark);
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: _pageController,
        children: [
          Dashboard(
            fullnameMeme: "علیرضا سلطانی نشان",
            userPersonalCodeMeme: "۹۸۱۱۱۰۳۳۳۰۲۰۱۶",
            avatarMeme: Image.asset("assets/images/Avatar.png"),
          ),
        ],
      )),
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
              title: Text(
                '',
              ),
              icon: CircleAvatar(
                backgroundColor: loginBtnColor,
                radius: 25,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                reserveText,
                style: TextStyle(fontFamily: mainFaFontFamily),
              ),
              icon: Icon(
                Icons.local_library,
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
