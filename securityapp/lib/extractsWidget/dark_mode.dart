import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          // color: themeChange.darkTheme ? cardStyleColorDark : Colors.white,
          borderRadius: BorderRadius.circular(1.0)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTileSwitch(
          value: themeChange.darkTheme,
          onChanged: (bool value) {
            themeChange.darkTheme = value;
          },
          leading: Container(
            margin: EdgeInsets.only(right: 20),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: HexColor("#0075FF"),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                CupertinoIcons.wand_stars,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          title: Text(
            "حالت تاریک",
            style: TextStyle(
              fontFamily: mainFontFamily,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
