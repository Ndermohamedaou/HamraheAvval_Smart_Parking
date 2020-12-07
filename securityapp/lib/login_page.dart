import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';
import 'extractsWidget/login_extract_text_fields.dart';

String user_email = "";
String user_password = "";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              print(
                  "your username: ${user_email} \n your password ${user_password}");
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: themeChange.darkTheme
                  ? Image.asset(
                      "assets/images/haDark.png",
                      width: 200,
                      height: 200,
                    )
                  : Image.asset(
                      "assets/images/haLight.png",
                      width: 200,
                      height: 200,
                    ),
            ),
            Text(
              'خوش آمدید',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextFields(
              lblText: "شماره تلفن یا ایمیل شما",
              textFieldIcon: Icons.contacts_outlined,
              onChangeText: (username) {
                setState(() {
                  user_email = username;
                });
              },
            ),
            SizedBox(height: 20),
            TextFields(
              lblText: "گذرواژه",
              textFieldIcon: Icons.vpn_key_outlined,
              onChangeText: (password) {
                setState(() {
                  user_password = password;
                });
              },
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgetPassword');
                  },
                  child: Text(
                    "گذرواژه خود را فراموش کرده اید؟",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: Text(
                  'فعال سازی تاریک / روشن',
                  style: TextStyle(fontSize: 20, fontFamily: 'BYekan'),
                ),
                leading: Checkbox(
                  value: themeChange.darkTheme,
                  onChanged: (bool value) {
                    themeChange.darkTheme = value;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
