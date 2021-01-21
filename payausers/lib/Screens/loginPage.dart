import 'package:flutter/material.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:toast/toast.dart';

String personalCode = "";
String password = "";
dynamic emptyTextFieldErrPersonalCode = null;
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
    // LStorage
    final lStorage = FlutterSecureStorage();
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
    // Final Navigation to? it's super temporary

    void prepareUserAccount(token) async {
      print(token);
    }

    void navigatedToDashboard({email, pass}) async {
      try {
        Map getLoginThridParity =
            await api.getAccessToLogin(email: email, password: pass);
        if (getLoginThridParity["status"] == "200") {
          if (getLoginThridParity["first_visit"]) {
            print("First visit is true");
          } else {
            prepareUserAccount(getLoginThridParity['token']);
          }
        }
        // Navigator.pushNamed(context, '/dashboard');
      } catch (e) {
        Toast.show(e.toString(), context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
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
                // errText:
                //     emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
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
                // errText: emptyTextFieldErrPassword == null
                //     ? null
                //     : emptyTextFieldMsg,
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
                        Icon(Icons.lock, color: lockDownColor),
                        SizedBox(width: 10),
                        Text(
                          forgetPass,
                          style: TextStyle(
                              fontFamily: mainFaFontFamily,
                              color: forgetOptionColor),
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
          color: loginBtnColor,
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
