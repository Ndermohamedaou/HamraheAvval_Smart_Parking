import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/classes/SharedClass.dart';
import 'package:securityapp/controller/safe_control_settings.dart';
import '../constFile/ConstFile.dart';
import '../constFile/texts.dart';
import 'dark_mode.dart';
import 'optStyle.dart';
import '../constFile/global_var.dart';
import 'package:securityapp/classes/SavingLocalStorage.dart';

// Getting instance of lds class
LocalizationDataStorage lds = LocalizationDataStorage();

// Setting Section in HomeScreen (main)
class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: cardStyleColor,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: imagePath == null
                            ? AssetImage("assets/images/profile.png")
                            : imagePath is File
                                ? FileImage(File(imagePath))
                                : AssetImage("assets/images/profile.png"),
                      ),
                    ),
                    Text(
                      username,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: mainFontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                          color: Colors.grey.shade200,
                          fontFamily: mainFontFamily,
                          fontSize: 15),
                    ),
                    Text(
                      personalCode,
                      style: TextStyle(
                          color: Colors.grey.shade200,
                          fontFamily: mainFontFamily,
                          fontSize: 15),
                    ),
                    Text(
                      "ساختمان ${securityManPositionFA}",
                      style: TextStyle(
                          color: Colors.grey.shade200,
                          fontFamily: mainFontFamily,
                          fontSize: 15),
                    ),
                  ],
                )),
            DarkModeWidget(themeChange: themeChange),
            OptionsViewer(
              text: ipAddressesList,
              desc: ipAddressesListDesc,
              avatarBgColor: Colors.yellow,
              avatarIcon: Icons.privacy_tip_outlined,
              iconColor: Colors.black,
            ),
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
    );
  }
}
