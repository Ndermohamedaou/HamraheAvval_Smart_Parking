import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Settings extends StatelessWidget {
  const Settings({this.fullNameMeme, this.avatarMeme});

  final fullNameMeme;
  final avatarMeme;

  @override
  Widget build(BuildContext context) {
    // print("Avatar Meme: $avatarMeme");
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final themeIconLeading = themeChange.darkTheme
        ? Icon(Icons.brightness_5, color: Colors.yellow)
        : Icon(Icons.bedtime, color: Colors.blue);

    var size = MediaQuery.of(context).size;

    final sliverTabSize = size.width > 1000 ? 1000.0 : 400.0;

    void logoutSection() {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        // backgroundColor: ,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_circle_down_sharp,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                maxRadius: 30,
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.warning_amber_sharp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.0.h),
              Text(
                "خروج از حساب",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 25.0,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.0.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  logoutMsg,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontFamily: mainFaFontFamily, fontSize: 20.0),
                ),
              ),
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  MaterialButton(
                    color: mainCTA,
                    minWidth: 100.0,
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.popUntil(context, ModalRoute.withName("/"));
                    },
                    child: Text(
                      "بلی",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 14.0,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    minWidth: 100.0,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "خیر",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 14.0,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0.h),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
            expandedHeight: sliverTabSize,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                fullNameMeme,
                style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 15),
              ),
              background: Image(
                image: NetworkImage(avatarMeme),
                fit: BoxFit.cover,
              ),
            ),
            leading: SizedBox()),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              width: double.infinity,
                              height: 55,
                              color: themeChange.darkTheme ? darkBar : lightBar,
                              child: FlatButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, "/settings"),
                                child: ListTile(
                                  title: Text(
                                    "تنظیمات",
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        fontSize: 15),
                                  ),
                                  leading: Icon(
                                    Icons.settings,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                              )),
                          SizedBox(height: 10),
                          Container(
                              width: double.infinity,
                              height: 55,
                              color: themeChange.darkTheme ? darkBar : lightBar,
                              child: FlatButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, "/myPlate"),
                                child: ListTile(
                                  title: Text(
                                    myPlateText,
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        fontSize: 15),
                                  ),
                                  leading: Icon(
                                    Icons.car_repair,
                                    color: HexColor("#D800BF"),
                                    size: 30,
                                  ),
                                ),
                              )),
                          SizedBox(height: 10),
                          Container(
                            color: themeChange.darkTheme ? darkBar : lightBar,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: ListTileSwitch(
                                leading: themeIconLeading,
                                value: themeChange.darkTheme,
                                onChanged: (bool state) {
                                  themeChange.darkTheme = state;
                                },
                                title: Text(
                                  themeModeSwitch,
                                  style: TextStyle(
                                      fontFamily: mainFaFontFamily,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: FlatButton(
                              onPressed: () => logoutSection(),
                              child: Text(
                                logoutBtnText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontFamily: mainFaFontFamily,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              childCount: 1),
        )
      ],
    );
  }
}
