import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:provider/provider.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import "package:payausers/ConstFiles/constText.dart";

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(themeChange.darkTheme
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark);
    PageController _pageContoller = PageController();

    int tabBarIndex = 0;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: PageView(
            children: [
              Container(
                child: Text("Tab1"),
              ),
              Container(
                child: Text("Tab2"),
              ),
              Container(
                child: Text("Tab3"),
              ),
              Container(
                child: Text("Tab4"),
              ),
              Container(
                child: Text("Tab5"),
              ),
            ],
            physics: NeverScrollableScrollPhysics(),
            controller: _pageContoller,
            onPageChanged: (value) {
              setState(() {
                tabBarIndex = value;
              });
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeChange.darkTheme ? darkBar : lightBar,
        selectedItemColor: HexColor('#21d9ad'),
        unselectedItemColor: HexColor('#545c69'),
        iconSize: 35,
        unselectedIconTheme: IconThemeData(size: 25),
        selectedFontSize: 16,
        unselectedFontSize: 14,
        currentIndex: tabBarIndex,
        onTap: (indexValue) {
          setState(() {
            tabBarIndex = indexValue;
            _pageContoller.animateToPage(tabBarIndex,
                duration: Duration(milliseconds: 3), curve: Curves.ease);
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text(
              settingsText,
              style: TextStyle(
                  color: HexColor("#C9C9C9"), fontFamily: mainFaFontFamily),
            ),
            icon: Icon(
              Icons.account_circle,
              color: HexColor("#C9C9C9"),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              reserveText,
              style: TextStyle(
                  color: HexColor("#C9C9C9"), fontFamily: mainFaFontFamily),
            ),
            icon: Icon(
              Icons.local_library,
              color: HexColor("#C9C9C9"),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              '',
              style: TextStyle(color: HexColor("#C9C9C9")),
            ),
            icon: CircleAvatar(
              backgroundColor: loginBtnColor,
              radius: 25,
              child: Icon(
                Icons.add,
                color: HexColor("#FFFFFF"),
              ),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              transactionText,
              style: TextStyle(
                  color: HexColor("#C9C9C9"), fontFamily: mainFaFontFamily),
            ),
            icon: Icon(
              Icons.view_day,
              color: HexColor("#C9C9C9"),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              dashboardText,
              style: TextStyle(
                  color: HexColor("#C9C9C9"), fontFamily: mainFaFontFamily),
            ),
            icon: Icon(
              Icons.view_quilt,
              color: HexColor("#C9C9C9"),
            ),
          ),
        ],
      ),
    );
  }
}
