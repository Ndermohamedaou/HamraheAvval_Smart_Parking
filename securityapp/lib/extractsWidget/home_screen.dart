import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mjpeg/mjpeg.dart';
import 'package:securityapp/constFile/texts.dart';
import '../adding_data.dart';
import '../constFile/ConstFile.dart';
import 'package:securityapp/extractsWidget/optStyle.dart';
import 'extract_main_design.dart';

// Service Section in HomeScreen (main)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}

// Setting Section in HomeScreen (main)
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
