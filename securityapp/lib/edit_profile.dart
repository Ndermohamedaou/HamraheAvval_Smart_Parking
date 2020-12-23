import 'dart:io';

import 'package:flutter/material.dart';
import 'package:securityapp/constFile/ConstFile.dart';

import 'constFile/global_var.dart';
import 'extractsWidget/login_extract_text_fields.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ویرایش پروفایل',
          style: TextStyle(fontFamily: mainFontFamily),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(

                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: imagePath == null
                          ? AssetImage("assets/images/profile.png")
                          : imagePath is File
                          ? FileImage(File(imagePath))
                          : AssetImage("assets/images/profile.png"),
                    ),
                    // title: TextFields(
                    //   initValue: "علیرضا سلطانی",
                    //
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
