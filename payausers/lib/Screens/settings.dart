import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/option_viewer.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/image_picker_controller.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toast/toast.dart';

// Controller to Convert image
import 'package:payausers/controller/change_avatar.dart';

import '../controller/flushbar_status.dart';

String userAvatar = "";
String userIdentify = "";
String userName = "";
String userEmail = "";
String userMelli = "";
String userPersonal = "";
String userRole = "";
String userSection = "";
File imgSource;
FlutterSecureStorage lds = FlutterSecureStorage();
ImageConversion imgConvertor = ImageConversion();

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
    AppLocalizations t = AppLocalizations.of(context);
    final avatarModel = Provider.of<AvatarModel>(context);
    ApiAccess api = ApiAccess(avatarModel.userToken);

    Future galleryViewer(ImageSource changeType) async {
      FlutterMediaPicker flutterMediaPicker = FlutterMediaPicker();
      final image = await flutterMediaPicker.pickImage(
        source: changeType,
      );

      setState(() => imgSource = image);
      try {
        if (imgSource != null) {
          // Getting endpoint of staffInfo
          Endpoint getStaffInfoEndpoint = apiEndpointsMap["auth"]["staffInfo"];
          // Go to Controller/changeAvatar.dart
          String result = await imgConvertor.sendingImage(imgSource);
          if (result == "200") {
            final userDetails = await api.requestHandler(
                getStaffInfoEndpoint.route, getStaffInfoEndpoint.method, {});
            final userAvatarChanged = userDetails["avatar"];
            await lds.write(key: "avatar", value: userAvatarChanged);
            final testAvatar = await lds.read(key: "avatar");

            if (testAvatar != "") {
              // Update Avatar in Provider
              avatarModel.fetchUserAvatar;
              showStatusInCaseOfFlush(
                  context: context,
                  title: t.translate("settings.avatarChangedTitle"),
                  msg: t.translate("settings.avatarChangedDesc"),
                  mainBackgroundColor: "#00c853",
                  iconColor: Colors.white,
                  icon: Icons.done_outline);
            }
          } else {
            Toast.show(t.translate("global.errors.serverError"), context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                textColor: Colors.white);
          }
        }
      } catch (e) {
        // print(e);
        showStatusInCaseOfFlush(
            context: context,
            title: t.translate("global.errors.serverError"),
            msg: t.translate("global.errors.connectionFailed"),
            iconColor: Colors.white,
            icon: Icons.remove_done);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          t.translate("settings.bottomNavigationName"),
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
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
                uId: avatarModel.userID,
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
                  t.translate("settings.settingNewAvatar"),
                  style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      fontSize: 18,
                      color: Colors.blue),
                ),
              ),
              TileInfo(
                textTitle: t.translate("settings.readOnlyFields.userFullName"),
                textSubtitle: userName,
              ),
              TileInfo(
                textTitle: t.translate("settings.readOnlyFields.email"),
                textSubtitle: userEmail,
              ),
              TileInfo(
                textTitle: t.translate("settings.readOnlyFields.personalCode"),
                textSubtitle: userPersonal,
              ),
              TileInfo(
                textTitle: t.translate("settings.readOnlyFields.nationalCode"),
                textSubtitle: userMelli,
              ),
              FlatButton(
                onPressed: () =>
                    Navigator.pushNamed(context, "/changePassword"),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    t.translate("recoverPassword.appBar"),
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
          color: mainSectionCTA,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              t.translate("global.actions.submitChanges"),
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

class TileInfo extends StatelessWidget {
  const TileInfo({
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
