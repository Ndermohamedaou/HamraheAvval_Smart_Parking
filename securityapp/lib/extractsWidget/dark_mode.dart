import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:securityapp/classes/SharedClass.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'package:securityapp/constFile/texts.dart';

class DarkModeWidget extends StatelessWidget {
  const DarkModeWidget({
    Key key,
    @required this.themeChange,
  }) : super(key: key);

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: appBarBackgroundColor,
          borderRadius: BorderRadius.circular(15.0)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTileSwitch(
          value: themeChange.darkTheme,
          onChanged: (bool value) {
            themeChange.darkTheme = value;
          },
          leading: Icon(
            CupertinoIcons.wand_stars,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            "حالت تاریک",
            style: TextStyle(
                fontFamily: mainFontFamily,
                fontSize: fontTitleSize,
                color: Colors.white),
          ),
          subtitle: Text(darkModeText,
              style: TextStyle(
                  fontFamily: mainFontFamily,
                  fontSize: 15,
                  color: Colors.white54)),
        ),
      ),
    );
  }
}
