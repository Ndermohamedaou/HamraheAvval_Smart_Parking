import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:payausers/Model/ChangeAvatar.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Controller to Convert image

String userAvatar = "";
String userIdentify = "";
String userName = "";
String userEmail = "";
String userMelli = "";
String userPersonal = "";
String userRole = "";
String userSection = "";
String imgSource;

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
    final avatarModel = Provider.of<AvatarModel>(context);

    Future galleryViewer() async {
      // Getting user token from LDS
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final pickedImage =
          await ImagePickerWeb.getImage(outputType: ImageType.bytes);

      ChangeArg ch = ChangeArg(pickedImage);

      Navigator.pushNamed(context, "/loadedTimeToChangeAvatar",
          arguments: ch.byteImg);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          settingsText,
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
                uA: NetworkImage(avatarModel.avatar),
                uId: userIdentify,
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
                textSubtitle: userPersonal,
              ),
              TilsInfo(
                textTitle: "شناسه ملی",
                textSubtitle: userMelli,
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
          color: mainSectionCTA,
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
