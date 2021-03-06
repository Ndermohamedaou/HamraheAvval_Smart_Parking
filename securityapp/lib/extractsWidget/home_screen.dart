import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/classes/SharedClass.dart';
import 'package:securityapp/constFile/texts.dart';
import '../adding_data.dart';
import 'package:securityapp/search_plate_section.dart';
import '../camera_grid.dart';
import '../constFile/ConstFile.dart';
import '../slots_view.dart';
import 'extract_main_design.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';

// Service Section in HomeScreen (main)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                // Expanded(
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         PageRouteBuilder(
                //           transitionDuration: Duration(milliseconds: 500),
                //           transitionsBuilder:
                //               (context, animation, animationTime, child) {
                //             animation = CurvedAnimation(
                //               parent: animation,
                //               curve: Curves.fastLinearToSlowEaseIn,
                //             );
                //             return ScaleTransition(
                //               alignment: Alignment.topLeft,
                //               scale: animation,
                //               child: child,
                //             );
                //           },
                //           pageBuilder: (context, animation, animationTime) {
                //             return CameraGridView();
                //           },
                //         ),
                //       );
                //     },
                //     child: service_card(
                //       colour:
                //           themeChange.darkTheme ? cardStyleColorDark : cardStyleColorLight,
                //       margin: cardStyleMargin,
                //       borderRadius: cardStyleBorderRadius,
                //       cardChild: ColContentClass(
                //         icon: FlatIcons.video_camera,
                //         iconSize: mainSecurityAppIconSize,
                //         fontFamily: mainSecurityAppFontFamily,
                //         fontSizeDesc: fontSizeDesc,
                //         fontSizeTitle: fontSizeTitle,
                //         iconColor: mainIconColor,
                //         textTitle: Camera,
                //         textTitleColor: themeChange.darkTheme ? cardStyleColorLight : cardStyleColorDark,
                //         textDesc: subCamera,
                //         textDescColor: themeChange.darkTheme ? cardStyleColorLight : cardStyleColorDark,
                //       ),
                //     ),
                //   ),
                // ),
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
                              alignment: Alignment.topRight,
                              scale: animation,
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, animationTime) {
                            return SearchPlateSection();
                          },
                        ),
                      );
                    },
                    child: service_card(
                      colour: themeChange.darkTheme ? cardStyleColorDark : cardStyleColorLight,
                      margin: cardStyleMargin,
                      borderRadius: cardStyleBorderRadius,
                      cardChild: ColContentClass(
                        icon: FlatIcons.search_1,
                        iconSize: mainSecurityAppIconSize,
                        fontFamily: mainSecurityAppFontFamily,
                        fontSizeDesc: fontSizeDesc,
                        fontSizeTitle: fontSizeTitle,
                        iconColor: mainIconColor,
                        textTitle: plakSearcher,
                        textTitleColor: themeChange.darkTheme ? HexColor('#f9f9f9'): cardStyleColorDark,
                        textDesc: subPlakSearcher,
                        textDescColor: themeChange.darkTheme ? HexColor('#f9f9f9') : cardStyleColorDark,
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
                              alignment: Alignment.bottomLeft,
                              scale: animation,
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, animationTime) {
                            return SlotsView();
                          },
                        ),
                      );
                    },
                    child: service_card(
                      colour: themeChange.darkTheme ? cardStyleColorDark : cardStyleColorLight,
                      margin: cardStyleMargin,
                      borderRadius: cardStyleBorderRadius,
                      cardChild: ColContentClass(
                        icon: FlatIcons.map_location,
                        iconSize: mainSecurityAppIconSize,
                        fontFamily: mainSecurityAppFontFamily,
                        fontSizeDesc: fontSizeDesc,
                        fontSizeTitle: fontSizeTitle,
                        iconColor: mainIconColor,
                        textTitle: garageSituation,
                        textTitleColor: themeChange.darkTheme ? cardStyleColorLight : cardStyleColorDark,
                        textDesc: subGarageSituation,
                        textDescColor: themeChange.darkTheme ? cardStyleColorLight : cardStyleColorDark,
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
                      colour: themeChange.darkTheme ? cardStyleColorDark : cardStyleColorLight,
                      margin: cardStyleMargin,
                      borderRadius: cardStyleBorderRadius,
                      cardChild: ColContentClass(
                        icon: FlatIcons.add_1,
                        iconSize: mainSecurityAppIconSize,
                        fontFamily: mainSecurityAppFontFamily,
                        fontSizeDesc: fontSizeDesc,
                        fontSizeTitle: fontSizeTitle,
                        iconColor: mainIconColor,
                        textTitle: addingVehicle,
                        textTitleColor: themeChange.darkTheme ? cardStyleColorLight : cardStyleColorDark,
                        textDesc: subAddingVehicle,
                        textDescColor: themeChange.darkTheme ? cardStyleColorLight : cardStyleColorDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
