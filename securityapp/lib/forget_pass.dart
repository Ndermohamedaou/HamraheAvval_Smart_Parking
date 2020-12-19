import 'package:flutter/material.dart';
import 'constFile/ConstFile.dart';
import 'extractsWidget/login_extract_text_fields.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'extractsWidget/bottom_button.dart';

String user_email = "";

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgetPassword(),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue[900],
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {},
            child: Text(
              forgetTextButton,
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

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Image.asset(
                "assets/images/forget_pass.png",
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                greetingMsg,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: loginTextFontFamily,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            TextFields(
              textFieldIcon: Icons.mark_email_read_outlined,
              textInputType: false,
              lblText: phoneOrEmail,
              readOnly: false,
              onChangeText: (email) {
                setState(() {
                  user_email = email;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
