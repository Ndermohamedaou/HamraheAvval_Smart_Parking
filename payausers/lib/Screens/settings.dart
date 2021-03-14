import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/optionViewer.dart';
import 'package:payausers/Screens/confirmInfo.dart';
import 'package:payausers/Screens/maino.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toast/toast.dart';

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
FlutterSecureStorage lds = FlutterSecureStorage();

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
    FlutterSecureStorage lds = FlutterSecureStorage();
    String avatar = await lds.read(key: "avatar");
    String userId = await lds.read(key: "user_id");
    String userName = await lds.read(key: "name");
    String email = await lds.read(key: "email");
    String personalC = await lds.read(key: "personal_code");
    String melliC = await lds.read(key: "melli_code");
    String section = await lds.read(key: "section");
    String role = await lds.read(key: "role");

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
    // final themeChange = Provider.of<DarkThemeProvider>(context);

    Future galleryViewer(ImageSource changeType) async {
      final image = await ImagePicker.pickImage(source: changeType);
      setState(() {
        imgSource = image;
      });
      try {
        if (imgSource != null) {
          // Go to Controller/changeAvatar.dart
          String result = await sendingImage(imgSource);
          if (result == "200") {
            // print(result);
            final uToken = await lds.read(key: "token");
            final userDetails = await api.getStaffInfo(token: uToken);
            final userAvatarChanged = userDetails["avatar"];
            await lds.write(key: "avatar", value: userAvatarChanged);
            final testAvatar = await lds.read(key: "avatar");
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
      appBar: AppBar(
        backgroundColor: mainCTA,
        centerTitle: true,
        title: Text(
          settingsText,
          style:
              TextStyle(fontFamily: mainFaFontFamily, fontSize: subTitleSize),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              SettingCircle(
                uA: imgSource == null
                    ? NetworkImage(userAvatar)
                    : FileImage(imgSource),
                uId: userId,
              ),
              FlatButton(
                onPressed: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    enableDrag: true,
                    bounce: true,
                    duration: const Duration(milliseconds: 550),
                    builder: (context) => SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: GalleryViewerOption(
                        cameraChoose: () {
                          Navigator.pop(context);
                          galleryViewer(ImageSource.camera);
                        },
                        galleryChoose: () {
                          Navigator.pop(context);
                          galleryViewer(ImageSource.gallery);
                        },
                      ),
                    ),
                  );
                },
                child: Text(
                  changeAvatarScreen,
                  style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      fontSize: 18,
                      color: Colors.blue),
                ),
              ),
              TilsInfo(
                textTitle: "نام کاربری",
                textSubtitle: userName,
              ),
              TilsInfo(
                textTitle: "نشانی پست الکترونیکی",
                textSubtitle: userEmail,
              ),
              TilsInfo(
                textTitle: "شناسه پرسنلی",
                textSubtitle: personalCodeText,
              ),
              TilsInfo(
                textTitle: "شناسه ملی",
                textSubtitle: melliCodeText,
              ),
              FlatButton(
                onPressed: () => Navigator.pushNamed(context, "/changeEmail"),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "ویرایش پست الکترونیکی",
                    style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      color: mainSectionCTA,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () =>
                    Navigator.pushNamed(context, "/changePassword"),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    chPass,
                    style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
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
          color: mainCTA,
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

class TilsInfo extends StatelessWidget {
  const TilsInfo({
    this.textTitle,
    this.textSubtitle,
  });

  final textTitle;
  final textSubtitle;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        title: Text(
          textTitle != null ? textTitle : "",
          style: TextStyle(fontFamily: mainFaFontFamily),
        ),
        subtitle: Text(
          textSubtitle != null ? textSubtitle : "",
          style: TextStyle(fontFamily: mainFaFontFamily),
        ),
      ),
    );
  }
}
