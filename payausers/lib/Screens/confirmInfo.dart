import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/controller/changeAvatar.dart';

Map<String, Object> userInfo;
File imgSource;
String email = "";
String password = "";
String rePassword = "";
dynamic emptyTextFieldErrEmailCode = null;
dynamic emptyTextFieldErrEmail = null;
dynamic emptyTextFieldErrPassword = null;
dynamic emptyTextFieldErrRePassword = null;

IconData showMePass = Icons.remove_red_eye;
bool protectedPassword = true;

class ConfirmScreen extends StatefulWidget {
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    // Getting Arguments from login page all about user info.
    userInfo = ModalRoute.of(context).settings.arguments;
    // print(userInfo);

    // Todo for next time
    void gettingLogin({email, pass, rePass, avatar}) async {
      final _img64 = img2Base64(avatar);
    }

    // Convert Image to base 64

    Future galleryViewer() async {
      final image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        imgSource = image;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "سلام، خوش آمدی",
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 20,
                            color: HexColor("#8B8B8B"),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(
                        userInfo['name'],
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              CircleAvatar(
                radius: circleAvatarRadiusSize,
                backgroundImage: imgSource != null
                    ? FileImage(imgSource)
                    : NetworkImage(userInfo['avatar']),
                child: Container(
                  margin: EdgeInsets.only(top: 150, left: 100),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        splashColor: Colors.black, // inkwell color
                        child: SizedBox(
                            width: 46,
                            height: 46,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        onTap: () => galleryViewer(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextFields(
                lblText: userEmailLbl,
                textFieldIcon: Icons.account_circle,
                textInputType: false,
                readOnly: false,
                errText:
                    emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
                onChangeText: (onChangeUsername) {
                  setState(() {
                    emptyTextFieldErrEmailCode = null;
                    email = onChangeUsername;
                  });
                },
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.fromLTRB(0, 10, 40, 0),
                child: Text(
                  causeOfEmail,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 15),
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
                    rePassword = onChangePassword;
                  });
                },
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
          color: loginBtnColor,
          child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                gettingLogin(
                    email: email,
                    pass: password,
                    rePass: rePassword,
                    avatar: imgSource);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    confirmLogin,
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
