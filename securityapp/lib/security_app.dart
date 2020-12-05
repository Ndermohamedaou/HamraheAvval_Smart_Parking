import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:securityapp/extractsWidget/optStyle.dart';
import 'extractsWidget/home_screen.dart';
import 'titleStyle/titles.dart';
import 'constFile/texts.dart';
import 'constFile/ConstFile.dart';

class InputSecurityApp extends StatefulWidget {
  @override
  _InputSecurityAppState createState() => _InputSecurityAppState();
}

class _InputSecurityAppState extends State<InputSecurityApp> {
  int tabBarIndex = 0;

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
              if (tabBarIndex == 0) {
                tabBarIndex = 1;
              } else {
                tabBarIndex = 0;
              }
            });
          },
          children: [
            tabBarIndex ? 0 : print('asdasd'): print('sada')
            HomeScreen(),
            Setting(),
          ],
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

class Setting extends StatelessWidget {
  const Setting({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  ':تنظمیات',
                  style: TextStyle(
                      fontFamily: 'BYekan',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/StylePage');
            },
            child: OptionsViewer(
              text: 'حالت شب و روز',
              desc:
              "شما میتوانید با استفاده از این گزینه از اپلیکیشن در هر محیطی متناسب با چشمان خود استفاده کنید",
              avatarBgColor: Colors.purple,
              avatarIcon: LineAwesomeIcons.lightbulb,
              iconColor: Colors.white,
            ),
          ),
          OptionsViewer(
            text: 'آدرس های آی پی',
            desc: "برای دسترسی به تمامی آدرس های آی پی کلیک کنید",
            avatarBgColor: Colors.yellow,
            avatarIcon: Icons.privacy_tip_outlined,
            iconColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
