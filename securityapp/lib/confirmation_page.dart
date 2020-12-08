import 'package:flutter/material.dart';

import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'extractsWidget/login_extract_text_fields.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              confirmText,
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
      body: _ConfirmationPage(),
    );
  }
}

class _ConfirmationPage extends StatefulWidget {
  @override
  __ConfirmationPageState createState() => __ConfirmationPageState();
}

class __ConfirmationPageState extends State<_ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Image.asset("assets/images/confirmPass.png"),
          ),
          SizedBox(height: 10),
          Text(
            greetingConfirmMsg,
            style: TextStyle(fontFamily: mainFontFamily, fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          TextFields(
            textInputType: false,
            lblText: "ایمیل یا شماره تلفن",
            textFieldIcon: Icons.email,
          ),
          SizedBox(height: 20),
          TextFields(
            textInputType: true,
            lblText: "گذرواژه",
            textFieldIcon: Icons.vpn_key_outlined,
          ),
          SizedBox(height: 20),
          TextFields(
            textInputType: true,
            lblText: " تایید گذرواژه",
            textFieldIcon: Icons.vpn_key_sharp,
          ),
        ],
      ),
    ));
  }
}
