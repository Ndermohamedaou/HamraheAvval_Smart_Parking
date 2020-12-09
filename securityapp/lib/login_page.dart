import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constFile/texts.dart';
import 'extractsWidget/bottom_button.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';
import 'extractsWidget/login_extract_text_fields.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool password_protected = true;
String user_email = "";
String user_password = "";
List results;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Getting users token with this Future life cycle
  // ignore: missing_return
  Future<List> gettingToken(email, pass) async {
    // final response = await Dio().post("xxx.com/api/login?email=${email}&password=${pass}");
    // try{
    //
    // }catch(ext){
    //
    // }
    // TODO If this is first time to append!
    // Status checker Statement with passing Token (arguments)
    // Navigator.pushNamed(context, '/confirmation');
    //  else time
    //   Navigator.pushNamed(context, '/main');
    // Saving primary data in secure storage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue[900],
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              gettingToken(user_email, user_password);
            },
            child: Text(
              loginText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: loginTextFontFamily,
                  fontSize: loginTextSize,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: themeChange.darkTheme
                  ? Image.asset(
                      "assets/images/haDark.png",
                      width: widthOfLoginLogo,
                    )
                  : Image.asset(
                      "assets/images/haLight.png",
                      width: widthOfLoginLogo,
                    ),
            ),
            Text(
              greetingText,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: mainFontFamily),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextFields(
              lblText: phoneOrEmail,
              textFieldIcon: Icons.contacts_outlined,
              textInputType: false,
              onChangeText: (username) {
                setState(() {
                  user_email = username;
                });
              },
            ),
            SizedBox(height: 20),
            TextFields(
              lblText: passwordLblText,
              maxLen: 20,
              textInputType: password_protected,
              textFieldIcon: user_password == ""
                  ? Icons.vpn_key_outlined
                  : Icons.remove_red_eye,
              iconPressed: () {
                setState(() {
                  password_protected
                      ? password_protected = false
                      : password_protected = true;
                });
              },
              onChangeText: (password) {
                setState(() {
                  user_password = password;
                });
              },
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgetPassword');
                  },
                  child: Text(
                    forgetTextButtonHint,
                    style: TextStyle(
                        fontFamily: mainFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: Text(
                  viewScreenLightOrDark,
                  style: TextStyle(fontSize: 20, fontFamily: mainFontFamily),
                ),
                leading: Container(
                  width: 60,
                  child: Switch(
                    activeColor: Colors.blue[700],
                    value: themeChange.darkTheme,
                    onChanged: (bool value) {
                      themeChange.darkTheme = value;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
