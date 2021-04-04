import 'package:flutter/foundation.dart' show TargetPlatform;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({this.fullNameMeme, this.avatarMeme});

  final fullNameMeme;
  final avatarMeme;

  @override
  Widget build(BuildContext context) {
    final targetPlatform =
        Theme.of(context).platform == TargetPlatform.iOS ? "iOS" : "Android";

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
                  fontSize: 16.0.sp,
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
                  style: TextStyle(
                      fontFamily: mainFaFontFamily, fontSize: 14.0.sp),
                ),
              ),
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  MaterialButton(
                    color: mainCTA,
                    minWidth: 45.0.w,
                    onPressed: () async {
                      FlutterSecureStorage lds = FlutterSecureStorage();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                      await lds.deleteAll();
                      prefs.clear();
                      Navigator.pushNamed(context, '/splashScreen');
                      exit(0);
                    },
                    child: Text(
                      "بلی",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 14.0.sp,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    minWidth: 45.0.w,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "خیر",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 14.0.sp,
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

    // print("Avatar Meme: $avatarMeme");
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final themeIconLeading = themeChange.darkTheme
        ? Icon(Icons.brightness_5, color: Colors.yellow)
        : Icon(Icons.bedtime, color: Colors.blue);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 70.0.w,
          floating: false,
          pinned: true,
          backgroundColor: mainCTA,
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
          leading: Container(
            margin: EdgeInsets.all(10),
            child: ClipOval(
              child: Material(
                color: mainCTA, // button color
                child: InkWell(
                  splashColor: mainSectionCTA, // inkwell color
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      )),
                  onTap: () => Navigator.pushNamed(context, "/settings"),
                ),
              ),
            ),
          ),
        ),
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
                                    size: 30,
                                  ),
                                ),
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.25,
                            indent: 20,
                            height: 0,
                          ),
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
                          Divider(
                            color: Colors.grey,
                            thickness: .25,
                            indent: 20,
                            height: 0,
                          ),
                          Container(
                              width: double.infinity,
                              height: 55,
                              color: themeChange.darkTheme ? darkBar : lightBar,
                              child: FlatButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, "/setBiometric"),
                                child: ListTile(
                                  title: Text(
                                    "تنظیم بایومتریک",
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        fontSize: 15),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      "assets/images/privacy.png",
                                      width: 25,
                                    ),
                                  ),
                                ),
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.25,
                            indent: 20,
                            height: 0,
                          ),
                          Container(
                              width: double.infinity,
                              height: 55,
                              color: themeChange.darkTheme ? darkBar : lightBar,
                              child: FlatButton(
                                onPressed: () => logoutSection(),
                                child: ListTile(
                                  title: Text(
                                    "خروج از حساب کاربری خود",
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        fontSize: 15),
                                  ),
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "توسعه داده شده توسط ارتباطات پایا نسخه ${targetPlatform}",
                              style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                fontSize: 10.0.sp,
                                color: Colors.grey,
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
