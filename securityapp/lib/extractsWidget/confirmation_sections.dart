import 'dart:io';

import 'package:flutter/material.dart';
import '../constFile/ConstFile.dart';
import '../constFile/texts.dart';
import 'login_extract_text_fields.dart';

class confirmInfoSec1 extends StatelessWidget {
  confirmInfoSec1(
      {this.initName,
      this.naturalCode,
      this.personalCode,
      this.gettingImage,
      this.imageFile});

  final String initName;
  final String naturalCode;
  final String personalCode;
  final Function gettingImage;
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 60),
          child: Column(
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: ExactAssetImage('assets/images/profile.png'),
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
                height: 50,
              ),
              TextFields(
                lblText: "شماره ملی",
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
                lblText: "شماره پرسنلی",
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
