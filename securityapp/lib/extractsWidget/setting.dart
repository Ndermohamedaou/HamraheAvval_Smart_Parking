import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../constFile/ConstFile.dart';
import '../constFile/texts.dart';
import 'optStyle.dart';
import '../constFile/global_var.dart';
import 'package:securityapp/classes/SavingLocalStorage.dart';
import 'package:securityapp/titleStyle/titles.dart';

// Getting instance of lds class
LocalizationDataStorage lds = LocalizationDataStorage();

// Setting Section in HomeScreen (main)
class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void viewDialog() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: AppBarTitleConfig(
                  titleText: logoutQa,
                  textStyles: TextStyle(
                      fontFamily: mainFontFamily, fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      AppBarTitleConfig(
                        titleText: aggregation,
                        textStyles: TextStyle(
                          fontFamily: mainFontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      agree,
                      style: TextStyle(fontFamily: mainFontFamily),
                    ),
                    onPressed: () {
                      lds.deleteUuToken();
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  TextButton(
                    child: Text(
                      deny,
                      style: TextStyle(fontFamily: mainFontFamily),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          });
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: cardStyleColor,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imagePath == null
                          ? AssetImage("assets/images/profile.png")
                          : imagePath is File
                              ? FileImage(File(imagePath))
                              : NetworkImage(imagePath),
                    ),
                    Text(
                      username,
                      style: TextStyle(
                          color: Colors.white, fontFamily: mainFontFamily),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                          color: Colors.white, fontFamily: mainFontFamily),
                    ),
                  ],
                )),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/StylePage');
              },
              child: OptionsViewer(
                text: themeModeSwitch,
                desc: themeModeSwitchDesc,
                avatarBgColor: Colors.purple,
                avatarIcon: LineAwesomeIcons.lightbulb,
                iconColor: Colors.white,
              ),
            ),
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
                  onPressed: () => viewDialog(),
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
