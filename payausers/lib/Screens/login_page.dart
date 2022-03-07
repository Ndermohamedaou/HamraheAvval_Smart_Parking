import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/Model/getting_ready_account.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/text_field_controller.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:toast/toast.dart';

String personalCode = "";
String password = "";
dynamic emptyTextFieldErrPersonalCode;
dynamic emptyTextFieldErrEmail;
dynamic emptyTextFieldErrPassword;
bool isLogin = false;
IconData showMePass = Icons.remove_red_eye;
bool protectedPassword = true;
ApiAccess api;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    personalCode = "";
    password = "";
    emptyTextFieldErrPersonalCode = null;
    emptyTextFieldErrEmail = null;
    emptyTextFieldErrPassword = null;
    isLogin = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    personalCode = "";
    password = "";
    emptyTextFieldErrPersonalCode = null;
    emptyTextFieldErrEmail = null;
    emptyTextFieldErrPassword = null;
    isLogin = false;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    final localData = Provider.of<AvatarModel>(context);
    // Accessing to Api
    api = ApiAccess(localData.userToken);
    // Setting dark theme provider class
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final String mainImgLogoLightMode = "assets/images/mainLogo.png";

    // Login process
    void navigatedToDashboard({email, pass}) async {
      GettingReadyAccount gettingReadyAccount = GettingReadyAccount();

      String devToken = "";
      try {
        devToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        devToken = "";
        print(e);
      }

      setState(() {
        email = email.trim();
        pass = pass.trim();
      });
      if (email != "" || pass != "") {
        try {
          setState(() => isLogin = true);
          Endpoint loginEndpoint = apiEndpointsMap["auth"]["login"];
          final getLoginStatus = await api.requestHandler(
              "${loginEndpoint.route}?personal_code=$email&password=$pass&DeviceToken=$devToken",
              loginEndpoint.method, {});

          // print(getLoginStatus);

          if (getLoginStatus["status"] == 200 ||
              getLoginStatus["status"] == "200") {
            if (getLoginStatus["first_visit"]) {
              Navigator.pushNamed(context, "/2factorAuth",
                  arguments: {"persCode": email, "password": pass});
              setState(() => isLogin = false);
            } else {
              setState(() => isLogin = false);
              // print("Your token: ${getLoginStatus["token"]}");

              gettingReadyAccount.getUserAccInfo(
                  getLoginStatus['token'], context);
              localData.refreshToken = getLoginStatus['token'];
            }
          } else {
            Toast.show(t.translate("global.errors.errorInLogin"), context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                textColor: Colors.white);
            setState(() => isLogin = false);
          }
        } catch (e) {
          setState(() => isLogin = false);
          // print("Error in self login ==> $e");
          Toast.show(
              t.translate("global.errors.wrongUsernameAndPassword"), context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } else {
        setState(() {
          emptyTextFieldErrEmail = t.translate("global.warnings.emptyBox");
          emptyTextFieldErrPassword = t.translate("global.warnings.emptyBox");
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(mainImgLogoLightMode),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                t.translate("appName"),
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontWeight: FontWeight.bold,
                  color: mainCTA,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                t.translate("login.loginToAccount"),
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextFields(
                lblText: t.translate("login.fields.personalCode"),
                keyboardType: TextInputType.number,
                textFieldIcon: Icons.account_circle,
                textInputType: false,
                readOnly: false,
                errText: emptyTextFieldErrEmail == null
                    ? null
                    : t.translate("global.warnings.emptyBox"),
                onChangeText: (onChangeUsername) {
                  setState(() {
                    emptyTextFieldErrEmail = null;
                    personalCode = onChangeUsername;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFields(
                lblText: t.translate("login.fields.password"),
                maxLen: 20,
                keyboardType: TextInputType.visiblePassword,
                readOnly: false,
                errText: emptyTextFieldErrPassword == null
                    ? null
                    : t.translate("global.warnings.emptyBox"),
                textInputType: protectedPassword,
                inputFormat: [
                  new WhitelistingTextInputFormatter(
                      RegExp("[-/:-?{-~!\"^_*'()@#\$%&=+,}0-9a-zA-Z]")),
                ],
                textFieldIcon:
                    password == "" ? Icons.vpn_key_outlined : showMePass,
                iconPressed: () {
                  setState(() {
                    protectedPassword
                        ? protectedPassword = false
                        : protectedPassword = true;
                    // Changing eye icon pressing
                    showMePass == Icons.remove_red_eye
                        ? showMePass = Icons.remove_red_eye_outlined
                        : showMePass = Icons.remove_red_eye;
                  });
                },
                onChangeText: (onChangePassword) {
                  setState(() {
                    emptyTextFieldErrPassword = null;
                    password = onChangePassword;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: FlatButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/forgetPassword"),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(Icons.lock, color: mainSectionCTA),
                      SizedBox(width: 10),
                      Text(
                        t.translate("login.forgetPassword"),
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            color: mainSectionCTA),
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: mainCTA,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () => !isLogin
                ? navigatedToDashboard(email: personalCode, pass: password)
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLogin
                    ? CupertinoActivityIndicator()
                    : Text(
                        t.translate("global.actions.enterOrGo"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: loginBtnTxtColor,
                            fontFamily: mainFaFontFamily,
                            fontSize: btnSized,
                            fontWeight: FontWeight.bold),
                      ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
