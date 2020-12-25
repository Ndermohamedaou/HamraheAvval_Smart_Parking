import 'dart:io';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/classes/SharedClass.dart';
import 'package:securityapp/controller/safe_control_settings.dart';
import '../constFile/ConstFile.dart';
import '../constFile/texts.dart';
import 'custom_divider.dart';
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
              margin: EdgeInsets.only(top: 50),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: Container(
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
                  title: Transform.translate(
                    offset: Offset(20, 0),
                    child: Text(
                      username,
                      style: TextStyle(
                          fontFamily: mainFontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  subtitle: Transform.translate(
                    offset: Offset(20, 0),
                    child: Text(
                      email,
                      style:
                          TextStyle(fontFamily: mainFontFamily, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),

            DarkModeWidget(themeChange: themeChange),

            Container(
                margin: EdgeInsets.only(right: 30),
                child: Divider(height: 20, thickness: 1)),
            // OptionsViewer(
            //   text: ipAddressesList,
            //   desc: ipAddressesListDesc,
            //   avatarBgColor: Colors.yellow,
            //   avatarIcon: Icons.privacy_tip_outlined,
            //   iconColor: Colors.black,
            // ),

            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: FlatButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/profile_details'),
                  child: ListTile(
                    leading: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: HexColor("#0075FF"),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.perm_identity_outlined,
                          size: 20,
                          color: Colors.white,
                        )),
                    title: Text(
                      "پروفايل من",
                      style:
                          TextStyle(fontFamily: mainFontFamily, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            CustomDivider(),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: ListTile(
                  leading: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: HexColor("#0075FF"),
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.privacy_tip_outlined,
                          size: 20, color: Colors.white)),
                  title: Text(
                    "نسخه",
                    style: TextStyle(fontFamily: mainFontFamily, fontSize: 18),
                  ),
                  subtitle: Text(
                    "1.0.1",
                    style: TextStyle(fontFamily: mainFontFamily, fontSize: 15),
                  ),
                ),
              ),
            ),
            CustomDivider(),
          ],
        ),
      ),
    );
  }
}
