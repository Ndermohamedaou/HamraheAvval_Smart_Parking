import 'package:flutter/material.dart';
import 'package:securityapp/titleStyle/titles.dart';
import 'package:provider/provider.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';

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
          Directionality(
            textDirection: TextDirection.rtl,
            child: ListTile(
              title: Text(
                'فعال سازی تاریک / روشن',
                style: TextStyle(fontSize: 20, fontFamily: 'BYekan'),
              ),
              leading: Checkbox(
                value: themeChange.darkTheme,
                onChanged: (bool value) {
                  themeChange.darkTheme = value;
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
