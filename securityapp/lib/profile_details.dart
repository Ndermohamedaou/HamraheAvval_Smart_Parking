import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'classes/SharedClass.dart';
import 'constFile/texts.dart';
import 'controller/safe_control_settings.dart';
import 'constFile/global_var.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final dynamic userDetailList = getUserDetailLds();
    print(userDetailList['username']);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                userDetailList['username'],
                style: TextStyle(fontFamily: mainFontFamily, fontSize: 15),
              ),
              background: Image(
                image: imagePath == null
                    ? AssetImage("assets/images/profile.png")
                    : imagePath is File
                        ? FileImage(File(imagePath))
                        : AssetImage("assets/images/profile.png"),
                fit: BoxFit.cover,
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
                            ListTile(
                              leading: Icon(
                                Icons.perm_identity_outlined,
                                size: 30,
                                color: HexColor("#9FA7C2"),
                              ),
                              title: Text(
                                "نام کاربری",
                                style: TextStyle(
                                    fontFamily: mainFontFamily,
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                              subtitle: Text(
                                userDetailList['username'],
                                style: TextStyle(
                                  fontFamily: mainFontFamily,
                                  fontSize: 20,
                                  color: themeChange.darkTheme
                                      ? cardStyleColorLight
                                      : cardStyleColorDark,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 30),
                              child: Divider(height: 20, thickness: 1),
                            ),
                            ListTile(
                              leading: Icon(Icons.email_outlined,
                                  size: 30, color: HexColor("#9FA7C2")),
                              title: Text(
                                "پست الکترونیکی",
                                style: TextStyle(
                                    fontFamily: mainFontFamily,
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                              subtitle: Text(
                                userDetailList['email'],
                                style: TextStyle(
                                  fontFamily: mainFontFamily,
                                  fontSize: 20,
                                  color: themeChange.darkTheme
                                      ? cardStyleColorLight
                                      : cardStyleColorDark,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 30),
                              child: Divider(height: 20, thickness: 1),
                            ),
                            ListTile(
                              leading: Icon(Icons.drive_file_rename_outline,
                                  size: 30, color: HexColor("#9FA7C2")),
                              title: Text(
                                "شناسه پرسنلی",
                                style: TextStyle(
                                    fontFamily: mainFontFamily,
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                              subtitle: Text(
                                userDetailList['personalCode'],
                                style: TextStyle(
                                  fontFamily: mainFontFamily,
                                  fontSize: 20,
                                  color: themeChange.darkTheme
                                      ? cardStyleColorLight
                                      : cardStyleColorDark,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 30),
                              child: Divider(height: 20, thickness: 1),
                            ),
                            ListTile(
                              leading: Icon(CupertinoIcons.building_2_fill,
                                  size: 30, color: HexColor("#9FA7C2")),
                              title: Text(
                                "ساختمان",
                                style: TextStyle(
                                    fontFamily: mainFontFamily,
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                              subtitle: Text(
                                userDetailList['securityManPositionFA'],
                                style: TextStyle(
                                  fontFamily: mainFontFamily,
                                  fontSize: 20,
                                  color: themeChange.darkTheme
                                      ? cardStyleColorLight
                                      : cardStyleColorDark,
                                ),
                              ),
                            ),
                            Divider(height: 20, thickness: 1),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.red.shade800,
                                child: MaterialButton(
                                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  onPressed: () => viewDialog(context),
                                  child: Text(
                                    logoutBtnText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: loginTextFontFamily,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
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
      ),
    );
  }
}
