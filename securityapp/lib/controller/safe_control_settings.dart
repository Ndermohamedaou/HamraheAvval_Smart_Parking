import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:securityapp/classes/SavingLocalStorage.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'package:securityapp/constFile/global_var.dart';
import 'package:securityapp/constFile/texts.dart';
import 'package:securityapp/titleStyle/titles.dart';

LocalizationDataStorage lds = LocalizationDataStorage();
// This function will be link with global_var file in repo
void loadingProfileImage() async {
  final lStorage = FlutterSecureStorage();
  imagePath = (await lStorage.read(key: "avatar"));
  username = await lStorage.read(key: "fullName");
  email = await lStorage.read(key: "email");
  personalCode = await lStorage.read(key: "personalCode");
  securityManPosition = await lStorage.read(key: "buildingName");
  securityManPositionFA = await lStorage.read(key: "buildingNameFA");
}

getUserDetailLds() {
  Map<String, dynamic> userDetails = {
    "imagePath": imagePath,
    "username": username,
    "email": email,
    "personalCode": personalCode,
    "securityManPosition": securityManPosition,
    "securityManPositionFA": securityManPositionFA
  };
  return userDetails;
}

// Getting logout
void viewDialog(context) {
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
