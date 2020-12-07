import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'extractsWidget/home_screen.dart';
import 'extractsWidget/setting.dart';
import 'titleStyle/titles.dart';
import 'constFile/texts.dart';
import 'constFile/ConstFile.dart';

class InputSecurityApp extends StatefulWidget {
  @override
  _InputSecurityAppState createState() => _InputSecurityAppState();
}

class _InputSecurityAppState extends State<InputSecurityApp> {
  // Index for count of 0..1 between difference screen
  int tabBarIndex = 0;

  // PageController for control two main screen in input page
  // and Navigate between!
  var _pageController = PageController();

  // Following is a list for two page as Widget
  var screens = [HomeScreen(), Setting()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleConfig(
          titleText: mainAppBarText,
          textStyles: TextStyle(
              fontSize: fontTitleSize,
              fontFamily: titleFontFamily,
              color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: PageView(
          onPageChanged: (value) {
            setState(() {
              tabBarIndex = value;
            });
          },
          controller: _pageController,
          children: screens,
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: HexColor('#0b172a'),
          selectedItemColor: HexColor('#21d9ad'),
          unselectedItemColor: HexColor('#545c69'),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          iconSize: 30,
          unselectedIconTheme: IconThemeData(size: 25),
          currentIndex: tabBarIndex,
          onTap: (currentIndex) {
            setState(() {
              tabBarIndex = currentIndex;
              _pageController.animateToPage(tabBarIndex,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text(
                'خانه',
                style: TextStyle(fontFamily: 'BYekan'),
              ),
              icon: Icon(LineAwesomeIcons.home),
            ),
            BottomNavigationBarItem(
              title: Text(
                'تنظیمات',
                style: TextStyle(fontFamily: 'BYekan'),
              ),
              icon: Icon(LineAwesomeIcons.hammer),
            ),
          ],
        ),
      ),
    );
  }
}
