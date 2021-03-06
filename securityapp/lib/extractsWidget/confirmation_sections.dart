import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:securityapp/classes/SharedClass.dart';
import 'package:securityapp/extractsWidget/text_buildings.dart';
import '../constFile/ConstFile.dart';
import '../constFile/texts.dart';
import 'login_extract_text_fields.dart';

class confirmInfoSec1 extends StatelessWidget {
  confirmInfoSec1({
    this.initName,
    this.naturalCode,
    this.personalCode,
    this.gettingImage,
    this.imageFile,
    this.themeChange,
  });

  final String initName;
  final String naturalCode;
  final String personalCode;
  final Function gettingImage;
  var imageFile;
  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: imageFile,
                child: Container(
                  margin: EdgeInsets.fromLTRB(120, 150, 0, 0),
                  child: FloatingActionButton(
                    onPressed: gettingImage,
                    child: CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextFields(
                lblText: fullName,
                initValue: initName,
                readOnly: true,
                textFieldIcon: Icons.drive_file_rename_outline,
                textInputType: false,
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.fromLTRB(0, 20, 40, 0),
                child: Text(
                  fullNameMsg,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: mainFontFamily,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFields(
                lblText: "?????????? ??????",
                initValue: naturalCode,
                readOnly: true,
                textFieldIcon: Icons.accessibility_outlined,
                textInputType: false,
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.fromLTRB(0, 20, 40, 0),
                child: Text(
                  naturalCodeTooltip,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: mainFontFamily,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFields(
                lblText: "?????????? ????????????",
                initValue: personalCode,
                readOnly: true,
                textFieldIcon: Icons.perm_identity_sharp,
                textInputType: false,
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.fromLTRB(0, 20, 40, 0),
                child: Text(
                  naturalCodeTooltip,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: mainFontFamily,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
