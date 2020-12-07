import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:securityapp/titleStyle/titles.dart';
import 'package:provider/provider.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';

class ScreenStyle extends StatefulWidget {
  @override
  _ScreenStyleState createState() => _ScreenStyleState();
}

class _ScreenStyleState extends State<ScreenStyle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleConfig(
          titleText: "سبک تاریک یا روشن",
          textStyles: TextStyle(
              fontSize: fontTitleSize,
              fontFamily: titleFontFamily,
              color: Colors.white),
        ),
      ),
      body: StylePage(),
    );
  }
}

class StylePage extends StatefulWidget {
  @override
  _StylePageState createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SafeArea(
      child: Column(
        children: [
          Container(
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
          ),
        ],
      ),
    );
  }
}
