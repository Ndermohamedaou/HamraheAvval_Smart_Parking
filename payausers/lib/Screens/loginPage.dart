import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payausers/Classes/SavingData.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:provider/provider.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:toast/toast.dart';

String personalCode = "";
String password = "";
dynamic emptyTextFieldErrPersonalCode = null;
dynamic emptyTextFieldErrEmail = null;
dynamic emptyTextFieldErrPassword = null;

IconData showMePass = Icons.remove_red_eye;

bool protectedPassword = true;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      if (email != "" || pass != "") {
        try {
          Map getLoginThridParity =
              await api.getAccessToLogin(email: email, password: pass);
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
              TextFields(
                lblText: personalCodePlaceHolder,
                textFieldIcon: Icons.account_circle,
                textInputType: false,
                readOnly: false,
                errText:
                    emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
                onChangeText: (onChangeUsername) {
                  setState(() {
                    emptyTextFieldErrPersonalCode = null;
                    personalCode = onChangeUsername;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFields(
                lblText: passwordPlaceHolder,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: FlatButton(
                    onPressed: () {
                      print("Forgot Btn Clicked!!");
                    },
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.lock, color: mainSectionCTA),
                        SizedBox(width: 10),
                        Text(
                          forgetPass,
                          style: TextStyle(
                              fontFamily: mainFaFontFamily,
                              color: mainSectionCTA),
                          textAlign: TextAlign.right,
                        )
                      ],
                    )),
              )
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
              onPressed: () {
                navigatedToDashboard(email: personalCode, pass: password);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    finalLoginText,
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
              )),
        ),
      ),
    );
  }
}
