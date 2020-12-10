import 'package:flutter/material.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'extractsWidget/login_extract_text_fields.dart';
import 'package:dio/dio.dart';
import 'package:toast/toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Define Main var global
// in this files and separate with other vars
String userEmail = "";
String userPassword = "";
String userConfirmPassword = "";
bool protectedPassword = true;
Map<String, Object> uToken;
// some validation in text fields
IconData showMePass = Icons.remove_red_eye;
dynamic emptyTextFieldErrEmail = null;
dynamic emptyTextFieldErrPass = null;
dynamic emptyTextFieldErrConfirmPass = null;

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  Dio dio = Dio();

  // To sending confirm information
  void confirmationProcessing(email, pass, confirmPass) async {
    // print("==========${uToken['userToken']}==========");
    if (email != "" || pass != "" || confirmPass != "") {
      if (pass == confirmPass) {
        if (pass.length > 6 && confirmPass.length > 6) {
          try {
            dio.options.headers['content-type'] = 'application/json';
            dio.options.headers['authorization'] =
                "Bearer ${uToken['userToken']}";
            Response response =
                await dio.get("http://10.0.2.2:8000/api/userInfo/");
            // show case
            print(response);
            // TODO
            // what does parameters will go to local storage? (with response List)
            // Token as String
            // await lStorage.write(key: "uToken", value: uToken);
            // fullName as String
            // email as String

          } catch (e) {
            print(e);
          }
        } else {
          Toast.show(lessThanLength, context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } else {
        Toast.show(notMatch, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    } else {
      setState(() {
        emptyTextFieldErrEmail = emptyTextFieldMsg;
        emptyTextFieldErrPass = emptyTextFieldMsg;
        emptyTextFieldErrConfirmPass = emptyTextFieldMsg;
      });
    }
  }

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
            onPressed: () {
              confirmationProcessing(
                  userEmail, userPassword, userConfirmPassword);
            },
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
  // Getting token from main login page as new arg in here

  @override
  Widget build(BuildContext context) {
    uToken = ModalRoute.of(context).settings.arguments;

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
            style: TextStyle(
                fontFamily: mainFontFamily,
                fontSize: 25,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          TextFields(
            textInputType: false,
            lblText: phoneOrEmail,
            textFieldIcon: Icons.email,
            errText: emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
            onChangeText: (email) {
              setState(() {
                emptyTextFieldErrEmail = null;
                userEmail = email;
              });
            },
          ),
          SizedBox(height: 20),
          TextFields(
            textInputType: protectedPassword,
            lblText: passwordLblText,
            maxLen: 20,
            textFieldIcon:
                userPassword == "" ? Icons.vpn_key_outlined : showMePass,
            errText: emptyTextFieldErrPass == null ? null : emptyTextFieldMsg,
            onChangeText: (pass) {
              setState(() {
                emptyTextFieldErrPass = null;
                userPassword = pass;
              });
            },
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
          ),
          SizedBox(height: 20),
          TextFields(
            maxLen: 20,
            textInputType: protectedPassword,
            lblText: confirmPasswordLblText,
            textFieldIcon:
                userConfirmPassword == "" ? Icons.vpn_key_outlined : showMePass,
            errText:
                emptyTextFieldErrConfirmPass == null ? null : emptyTextFieldMsg,
            onChangeText: (confirmPass) {
              setState(() {
                emptyTextFieldErrConfirmPass = null;
                userConfirmPassword = confirmPass;
              });
            },
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
          ),
        ],
      ),
    ));
  }
}
