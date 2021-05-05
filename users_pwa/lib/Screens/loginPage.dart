import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:payausers/Classes/SavingData.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:toast/toast.dart';

String personalCode = "";
String password = "";
dynamic emptyTextFieldErrPersonalCode = null;
dynamic emptyTextFieldErrEmail = null;
dynamic emptyTextFieldErrPassword = null;
bool isLogin = true;
IconData showMePass = Icons.remove_red_eye;

bool protectedPassword = true;

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
    isLogin = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accessing to Api
    ApiAccess api = ApiAccess();
    // Setting dark theme provider class
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final String mainImgLogoLightMode =
        "assets/images/Titile_Logo_Mark_light.png";
    final String mainImgLogoDarkMode =
        "assets/images/Titile_Logo_Mark_dark.png";
    final String mainLogo =
        themeChange.darkTheme ? mainImgLogoDarkMode : mainImgLogoLightMode;

    // If user is not new
    void getUserAccInfo(token) async {
      SavingData savingData = SavingData();
      try {
        Map userInfo = await api.getStaffInfo(token: token);
        // Convert plate list from api to lStorage
        // final List userPlates = userInfo["plates"] as List;

        bool result = await savingData.LDS(
          token: token,
          user_id: userInfo["user_id"],
          email: userInfo["email"],
          name: userInfo["name"],
          role: userInfo['role'],
          avatar: userInfo["avatar"],
          melli_code: userInfo['melli_code'],
          personal_code: userInfo['personal_code'],
          section: userInfo["section"],
          lastLogin: userInfo["last_login"],
        );

        // bool savingUserPlate = await savingData.savingPlate(plates: userPlates);

        if (result) {
          Navigator.pushNamed(context, "/loginCheckout");
        } else {
          Toast.show("Your info can not saved", context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } catch (e) {
        Toast.show("Error in Get User info!", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    }

    // Confirmation
    void goToConfirm(token) async {
      try {
        Map userInfo = await api.getStaffInfo(token: token);
        Navigator.pushNamed(context, "/confirm", arguments: {
          "userInfo": userInfo,
          "curPass": password,
          "token": token
        });
      } catch (e) {
        Toast.show("Can't Confirm you", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    }

    // Login process
    void navigatedToDashboard({email, pass}) async {
      setState(() {
        email = email.trim();
        pass = pass.trim();
      });
      if (email != "" && pass != "") {
        try {
          setState(() => isLogin = false);
          final user_device_token = await FirebaseMessaging.instance.getToken();
          Map getLoginThridParity = await api.getAccessToLogin(
              email: email, password: pass, deviceToken: user_device_token);
          if (getLoginThridParity["status"] == "200") {
            // Checking First visit
            if (getLoginThridParity["first_visit"]) {
              goToConfirm(getLoginThridParity['token']);
            } else {
              getUserAccInfo(getLoginThridParity['token']);
            }
          } else {
            Toast.show("خطا در ورود", context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                textColor: Colors.white);
          }
        } catch (e) {
          setState(() => isLogin = true);
          print(e);
          Toast.show("شماره پرسنلی یا گذرواژه اشتباه است", context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } else {
        setState(() {
          emptyTextFieldErrEmail = emptyTextFieldMsg;
          emptyTextFieldErrPassword = emptyTextFieldMsg;
        });
      }
    }

    var size = MediaQuery.of(context).size;
    final responsiveWidthTextFieldSize =
        size.width > 500 ? 500 : double.infinity;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Image.asset(mainLogo, width: 250),
                ),
              ),
              SizedBox(height: 30),
              Text(
                welcomeToInfo,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Container(
                width: responsiveWidthTextFieldSize,
                child: TextFields(
                  keyType: TextInputType.multiline,
                  lblText: personalCodePlaceHolder,
                  textFieldIcon: Icons.account_circle,
                  textInputType: false,
                  readOnly: false,
                  errText:
                      emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
                  onChangeText: (onChangeUsername) {
                    setState(() {
                      emptyTextFieldErrEmail = null;
                      emptyTextFieldErrPersonalCode = null;
                      personalCode = onChangeUsername;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: responsiveWidthTextFieldSize,
                child: TextFields(
                  keyType: TextInputType.visiblePassword,
                  lblText: passwordTextFieldPlace,
                  maxLen: 20,
                  readOnly: false,
                  errText: emptyTextFieldErrPassword == null
                      ? null
                      : emptyTextFieldMsg,
                  textInputType: protectedPassword,
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
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: responsiveWidthTextFieldSize,
                child: FlatButton(
                    onPressed: () {
                      print("Forgot Btn Clicked!!");
                    },
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.lock, color: mainCTA),
                        SizedBox(width: 10),
                        Text(
                          forgetPass,
                          style: TextStyle(
                              fontFamily: mainFaFontFamily, color: mainCTA),
                          textAlign: TextAlign.right,
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        hasCondition: isLogin,
        text: finalLoginText,
        ontapped: () =>
            navigatedToDashboard(email: personalCode, pass: password),
      ),
    );
  }
}
