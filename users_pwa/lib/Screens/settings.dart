import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_native_resizer/image_native_resizer.dart';
// Image Picker modules
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
//
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/optionViewer.dart';
import 'package:payausers/Screens/maino.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file/memory.dart';
import 'package:image_native_resizer/image_native_resizer.dart';

// Controller to Convert image
import 'package:payausers/controller/changeAvatar.dart';

import '../controller/flushbarStatus.dart';

String userAvatar = "";
String userIdentify = "";
String userName = "";
String userEmail = "";
String userMelli = "";
String userPersonal = "";
String userRole = "";
String userSection = "";
File imgSource;
ApiAccess api = ApiAccess();

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    gettingUserAvatar().then((value) {
      setState(() {
        userAvatar = value['avatar'];
        userIdentify = value['userId'];
        userName = value['userName'];
        userEmail = value['email'];
        userPersonal = value['personalCode'];
        userMelli = value['melliCode'];
        userSection = value['section'];
        userRole = value['role'];
      });
    });
  }

  Future<Map> gettingUserAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String avatar = prefs.getString("avatar");
    String userId = prefs.getString("user_id");
    String userName = prefs.getString("name");
    String email = prefs.getString("email");
    String personalC = prefs.getString("personal_code");
    String melliC = prefs.getString("melli_code");
    String section = prefs.getString("section");
    String role = prefs.getString("role");

    return {
      "avatar": avatar,
      "userId": userId,
      "userName": userName,
      "email": email,
      "personalCode": personalC,
      "melliCode": melliC,
      "section": section,
      "role": role
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    Future galleryViewer() async {
      // Getting user token from LDS
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Getting Files as Image source
      // FilePickerResult result =
      //     await FilePicker.platform.pickFiles(type: FileType.image);

      final img = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );

      final reSizeImgPath = await ImageNativeResizer.resize(
        imagePath: img.path,
        maxWidth: 512,
        maxHeight: 512,
        quality: 30,
      );
      // Ready to convert Img uri path to Image File
      File resizedImgFile = File(reSizeImgPath);
      // Ready to convert image file to byte code
      final bytesImg = resizedImgFile.readAsBytesSync();
      // Ready to encode byty image to base64
      String _img64 = base64Encode(bytesImg);

      // // print(await img.readAsBytes());
      // var byteImg = await img.readAsBytes();
      // String _img64 = base64Encode(byteImg);

      try {
        if (_img64 != null) {
          // Go to Controller/changeAvatar.dart
          String result = await sendingImage(_img64);
          print("Result of sending $result");
          if (result == "200") {
            // print(result);
            final uToken = prefs.getString("token");
            final userDetails = await api.getStaffInfo(token: uToken);
            final userAvatarChanged = userDetails["avatar"];
            print(userAvatarChanged);
            await prefs.setString("avatar", userAvatarChanged);
            final testAvatar = prefs.getString("avatar");
            // print("LOCAL IMAGE SUBMITED NEW -------> $testAvatar");
            if (testAvatar != "") {
              showStatusInCaseOfFlush(
                  context: context,
                  title: "",
                  msg: sendSuccessful,
                  iconColor: Colors.green,
                  icon: Icons.done_outline);
            } else {
              showStatusInCaseOfFlush(
                  context: context,
                  title: "",
                  msg: sendFailed,
                  iconColor: Colors.red,
                  icon: Icons.remove_done);
            }
          } else {
            Toast.show(sendServerFailed, context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                textColor: Colors.white);
          }
        } else {
          showStatusInCaseOfFlush(
              context: context,
              title: "",
              msg: sendDenied,
              iconColor: Colors.red,
              icon: Icons.remove_done);
        }
      } catch (e) {
        print(e);
        showStatusInCaseOfFlush(
            context: context,
            title: "",
            msg: sendDenied,
            iconColor: Colors.red,
            icon: Icons.remove_done);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                    color: themeChange.darkTheme ? darkBar : lightBar),
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.arrow_back_ios_rounded)),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              settingsText,
                              style: TextStyle(
                                  fontFamily: mainFaFontFamily,
                                  fontSize: subTitleSize),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SettingCircle(
                      uA: imgSource == null
                          ? NetworkImage(userAvatar)
                          : FileImage(imgSource),
                      uId: userId,
                    ),
                    FlatButton(
                      onPressed: () => galleryViewer(),
                      child: Text(
                        changeAvatarScreen,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextShow(
                        title: userName,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            userEmail,
                            style: TextStyle(
                              fontFamily: mainEnFontFamily,
                              fontSize: 16,
                            ),
                          ),
                          FlatButton(
                            minWidth: 5,
                            onPressed: () =>
                                Navigator.pushNamed(context, "/changeEmail"),
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(readOnlyInfo,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                height: 86,
                color: themeChange.darkTheme ? darkBar : lightBar,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Rowed(
                      title: personalCodeText,
                      realPost: userPersonal,
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                    Rowed(title: melliCodeText, realPost: userMelli),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: FlatButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/changePassword"),
                  child: Center(
                    child: Text(
                      chPass,
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 18,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.blue,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              submitAvatarChanged,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: mainFaFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class Rowed extends StatelessWidget {
  const Rowed({this.title, this.realPost});

  final title;
  final realPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 16)),
          Text(realPost,
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 16)),
        ],
      ),
    );
  }
}

class TextShow extends StatelessWidget {
  const TextShow({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title,
              style: TextStyle(fontFamily: mainEnFontFamily, fontSize: 16)),
        ],
      ),
    );
  }
}

class SettingCircle extends StatelessWidget {
  const SettingCircle({this.uA, this.uId});

  final ImageProvider uA;
  final String uId;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 75,
      backgroundImage: uA,
      child: Container(
        margin: EdgeInsets.only(top: 110, left: 110),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            color: HexColor("#EBEAFA"),
            borderRadius: BorderRadius.circular(2.0)),
        child: QrImage(
          data: uId,
          version: QrVersions.auto,
          padding: EdgeInsets.all(4),
          foregroundColor: HexColor("#000000"),
        ),
      ),
    );
  }
}
