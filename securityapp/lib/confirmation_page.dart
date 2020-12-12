import 'dart:io';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'extractsWidget/login_extract_text_fields.dart';
import 'package:dio/dio.dart';
import 'extractsWidget/confirmation_sections.dart';
import 'package:toast/toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Index of page for forward ahead with btn
int pageIndex = 0;
// On Break
bool breakConfirm = false;
// Define Main var global
// in this files and separate with other vars
String userEmail = "";
String userPassword = "";
String userConfirmPassword = "";
bool protectedPassword = true;
Map<String, Object> userInfo;
String uToken;
File imgSource;
// some validation in text fields
IconData showMePass = Icons.remove_red_eye;
dynamic emptyTextFieldErrEmail = null;
dynamic emptyTextFieldErrPass = null;
dynamic emptyTextFieldErrConfirmPass = null;
// Creating PageController for forwarding ahead with btn
// without use swapping finger on screen
PageController _pageController = PageController();
// Duration to apply in next or prv page
Duration _duration = new Duration(milliseconds: 500);

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  Dio dio = Dio();

  // Local Storage Super Secure!
  final lStorage = FlutterSecureStorage();

  // To sending confirm information
  void confirmationProcessing(email, pass, confirmPass, uToken) async {
    // I will use userInfo Map for storing data in local
    if (email != "" || pass != "" || confirmPass != "") {
      if (pass == confirmPass) {
        if (pass.length > 6 && confirmPass.length > 6) {
          // Prepare require data to updating user info
          // FormData userData = FormData.fromMap({"avatar": imgSource});
          var formData = FormData();
          formData.files.add(MapEntry(
              "avatar",
              await MultipartFile.fromFile(imgSource.path,
                  filename: "userAvatar.png")));
          try {
            print(
                "${email} -- ${pass} -- ${confirmPass} -- ${uToken} -- ${imgSource}");
            dio.options.headers['content-type'] = 'application/json';
            dio.options.headers['authorization'] = "Bearer ${uToken}";
            Response response = await dio.post(
                "http://10.0.2.2:8000/api/UpdateInfo?&email=${email}&password=${pass}",
                data: formData);
            // show case
            print(response.data);
            // TODO
            // what does parameters will go to local storage? (with response List)
            // Token as String
            // await lStorage.write(key: "uToken", value: uToken);
            // fullName as String
            // email as String

          } catch (e) {
            // Toast.show(serverNotResponse, context,
            //     duration: Toast.LENGTH_LONG,
            //     gravity: Toast.BOTTOM,
            //     textColor: Colors.white);
            print(e);
          }
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
      bottomNavigationBar: breakConfirm
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blue[900],
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    confirmationProcessing(
                        userEmail, userPassword, userConfirmPassword, uToken);
                  },
                  child: Text(
                    completingForm,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: loginTextFontFamily,
                        fontSize: loginTextSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blue[900],
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    // confirmationProcessing(
                    //     userEmail, userPassword, userConfirmPassword);
                    _pageController.nextPage(
                        duration: _duration, curve: Curves.easeIn);
                    setState(() {
                      pageIndex == 0
                          ? breakConfirm = true
                          : breakConfirm = false;
                    });
                  },
                  child: Text(
                    nextConfirmPage,
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
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        title: Text(
          appBarConfirmationTitle,
          style: TextStyle(fontFamily: mainFontFamily),
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
  Future galleryViewer() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgSource = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Getting Arguments from login page all about user info.
    userInfo = ModalRoute.of(context).settings.arguments;
    uToken = userInfo['uToken'];
    userInfo = userInfo['userInfo'];

    return SafeArea(
      child: PageView(
        onPageChanged: (viewIndex) {
          setState(() {
            pageIndex = viewIndex;
          });
        },
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          confirmInfoSec1(
            initName: userInfo['name'],
            naturalCode: userInfo['melli_code'],
            personalCode: userInfo['personal_code'],
            imageFile: imgSource == null
                ? AssetImage('assets/images/profile.png')
                : FileImage(imgSource),
            gettingImage: () {
              galleryViewer();
            },
          ),
          buildSingleChildScrollView(),
        ],
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
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
            readOnly: false,
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
            readOnly: false,
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
            readOnly: false,
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
    );
  }
}
