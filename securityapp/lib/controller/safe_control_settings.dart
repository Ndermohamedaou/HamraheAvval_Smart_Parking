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

void insertPicSubmit(
  context,
  title,
) {}

Widget buildRowPlate(plate0, plate1, plate2, plate3) {
  return Container(
    width: double.infinity,
    height: 70,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.8),
        borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.blue[900],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 2),
              Image.asset(
                "assets/images/iranFlag.png",
                width: 35,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'I.R.',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'I R A N',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 50,
          height: 70,
          margin: EdgeInsets.only(top: 0),
          child: TextFormField(
            showCursor: false,
            readOnly: true,
            style: TextStyle(
                fontSize: 26,
                fontFamily: mainFontFamily,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            initialValue: plate0,
            decoration:
                InputDecoration(counterText: "", border: InputBorder.none),
            maxLength: 2,
          ),
        ),
        Container(
          width: 30,
          height: 70,
          child: TextFormField(
            showCursor: false,
            readOnly: true,
            style: TextStyle(
                fontSize: 26,
                fontFamily: mainFontFamily,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            initialValue: plate1,
            decoration:
                InputDecoration(counterText: "", border: InputBorder.none),
            maxLength: 2,
          ),
        ),
        Container(
          width: 50,
          height: 70,
          margin: EdgeInsets.only(top: 0, right: 0),
          child: TextFormField(
            readOnly: true,
            initialValue: plate2,
            style: TextStyle(
                fontSize: 26,
                fontFamily: mainFontFamily,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration:
                InputDecoration(counterText: "", border: InputBorder.none),
            maxLength: 3,
          ),
        ),
        VerticalDivider(width: 1, color: Colors.black, thickness: 3),
        Container(
          width: 50,
          height: 70,
          // margin: EdgeInsets.only(top: 0, right: 10),
          child: TextFormField(
            readOnly: true,
            initialValue: plate3,
            style: TextStyle(
                fontSize: 26,
                fontFamily: mainFontFamily,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration:
                InputDecoration(counterText: "", border: InputBorder.none),
            maxLength: 2,
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
    ),
  );
}

void showSearchResult(context, senderStatus) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          submissionTitleText,
          style: TextStyle(
              fontFamily: mainFontFamily, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                "${senderStatus["slot"]} :شماره جایگاه",
                style: TextStyle(fontFamily: mainFontFamily, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              buildRowPlate(
                  senderStatus["plate_fa0"],
                  senderStatus["plate_fa1"],
                  senderStatus["plate_fa2"],
                  senderStatus["plate_fa3"])
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(thanks, style: TextStyle(fontFamily: mainFontFamily)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
