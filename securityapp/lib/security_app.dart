import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'extractsWidget/extract_main_design.dart';
import 'titleStyle/titles.dart';
import 'constFile/texts.dart';
import 'constFile/ConstFile.dart';
import 'package:mjpeg/mjpeg.dart';
import 'adding_data.dart';

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
          textStyles:
              TextStyle(fontSize: fontTitleSize, fontFamily: titleFontFamily),
        ),
        backgroundColor: appBarBackgroundColor,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        ':خدمات',
                        style: TextStyle(
                            fontFamily: mainSecurityAppFontFamily,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Mjpeg.startLiveView(
                              //TODO Will be change with some state and functions
                              url: "rtsp://192.168.1.109:554/11");
                        },
                        child: service_card(
                          colour: cardStyleColor,
                          margin: cardStyleMargin,
                          borderRadius: cardStyleBorderRadius,
                          cardChild: ColContentClass(
                            icon: LineAwesomeIcons.alternate_shield,
                            iconSize: mainSecurityAppIconSize,
                            fontFamily: mainSecurityAppFontFamily,
                            fontSizeDesc: fontSizeDesc,
                            fontSizeTitle: fontSizeTitle,
                            iconColor: mainIconColor,
                            textTitle: Camera,
                            textTitleColor: textTitleColor,
                            textDesc: subCamera,
                            textDescColor: textDescColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: service_card(
                          colour: cardStyleColor,
                          margin: cardStyleMargin,
                          borderRadius: cardStyleBorderRadius,
                          cardChild: ColContentClass(
                            icon: LineAwesomeIcons.car,
                            iconSize: mainSecurityAppIconSize,
                            fontFamily: mainSecurityAppFontFamily,
                            fontSizeDesc: fontSizeDesc,
                            fontSizeTitle: fontSizeTitle,
                            iconColor: mainIconColor,
                            textTitle: plakSearcher,
                            textTitleColor: textTitleColor,
                            textDesc: subPlakSearcher,
                            textDescColor: textDescColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: service_card(
                          colour: cardStyleColor,
                          margin: cardStyleMargin,
                          borderRadius: cardStyleBorderRadius,
                          cardChild: ColContentClass(
                            icon: LineAwesomeIcons.map_marked,
                            iconSize: mainSecurityAppIconSize,
                            fontFamily: mainSecurityAppFontFamily,
                            fontSizeDesc: fontSizeDesc,
                            fontSizeTitle: fontSizeTitle,
                            iconColor: mainIconColor,
                            textTitle: garageSituation,
                            textTitleColor: textTitleColor,
                            textDesc: subGarageSituation,
                            textDescColor: textDescColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              transitionsBuilder:
                                  (context, animation, animationTime, child) {
                                animation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                );
                                return ScaleTransition(
                                  alignment: Alignment.bottomRight,
                                  scale: animation,
                                  child: child,
                                );
                              },
                              pageBuilder: (context, animation, animationTime) {
                                return AdddingDataMethods();
                              },
                            ),
                          );
                        },
                        child: service_card(
                          colour: cardStyleColor,
                          margin: cardStyleMargin,
                          borderRadius: cardStyleBorderRadius,
                          cardChild: ColContentClass(
                            icon: LineAwesomeIcons.address_book,
                            iconSize: mainSecurityAppIconSize,
                            fontFamily: mainSecurityAppFontFamily,
                            fontSizeDesc: fontSizeDesc,
                            fontSizeTitle: fontSizeTitle,
                            iconColor: mainIconColor,
                            textTitle: addingVehicle,
                            textTitleColor: textTitleColor,
                            textDesc: subAddingVehicle,
                            textDescColor: textDescColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), ),
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
