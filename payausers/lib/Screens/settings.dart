import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Screens/maino.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

String userAvatar = "";
String userIdentify = "";
String userName = "";
String userEmail = "";
String userMelli = "";
String userPersonal = "";
String userRole = "";
String userSection = "";

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
    final themeChange = Provider.of<DarkThemeProvider>(context);

    // print("This is => $userAvatar");
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
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                      uA: userAvatar,
                      uId: userId,
                    ),
                    SizedBox(height: 5),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        changeAvatarScreen,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 18),
                    Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                    SizedBox(height: 5),
                    TextShow(
                      title: userName,
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                    SizedBox(height: 5),
                    TextShow(
                      title: userEmail,
                    ),
                    SizedBox(height: 5),
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
                    Text("اطلاعات فقط برای نمایش هستند",
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 18,
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
                    SizedBox(height: 5),
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
            onPressed: () {},
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
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 20)),
          Text(realPost,
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 20)),
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
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 20)),
        ],
      ),
    );
  }
}

class SettingCircle extends StatelessWidget {
  const SettingCircle({this.uA, this.uId});

  final String uA;
  final String uId;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 75,
      backgroundImage: NetworkImage(uA),
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
