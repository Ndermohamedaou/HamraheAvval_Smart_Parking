import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/SavingData.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/Model/imageConvertor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/validator/textValidator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

import '../providers/avatar_model.dart';

Map<String, Object> userInfo;
Map<String, Object> modalRoute;

File imgSource;
String _image64 = "";
String password = "";
String rePassword = "";

dynamic emptyTextFieldErrPassword;
dynamic emptyTextFieldErrRePassword;
ImgConversion convertable = ImgConversion();
SavingData savingData = SavingData();
IconData showMePass = Icons.remove_red_eye;
bool protectedPassword = true;
// Is okay i go to confirm for 1st
bool isConfirm;

class ConfirmScreen extends StatefulWidget {
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  void initState() {
    imgSource = null;
    password = "";
    rePassword = "";
    emptyTextFieldErrPassword = null;
    emptyTextFieldErrRePassword = null;
    isConfirm = false;
    showMePass = Icons.remove_red_eye;
    protectedPassword = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Getting Arguments from login page all about user info.
    modalRoute = ModalRoute.of(context).settings.arguments;
    userInfo = modalRoute["userInfo"];
    final currentPass = modalRoute["curPass"];
    final uToken = modalRoute["token"];
    // Sending token to constructor of ApiAccess class.
    ApiAccess api = ApiAccess(uToken);
    AvatarModel localData = Provider.of<AvatarModel>(context);

    void gettingLogin({uToken, curPass, pass, rePass, String avatar}) async {
      if (pass != "" && rePass != "") {
        if (pass.length >= 6 && rePass.length >= 6) {
          if (pass == rePass) {
            bool testPass = passwordRegex(pass);
            bool testRePass = passwordRegex(rePass);

            if (testPass && testRePass) {
              try {
                setState(() => isConfirm = true);

                Endpoint updateStaffInfoEndpoint =
                    apiEndpointsMap["auth"]["updateStaffInfo"];

                final result = await api.requestHandler(
                    updateStaffInfoEndpoint.route,
                    updateStaffInfoEndpoint.method, {
                  "avatar": avatar,
                  "current_password": curPass,
                  "new_password": pass,
                });

                if (result["status"] == "200") {
                  // Saving data to local
                  Endpoint staffInfoEndpoint =
                      apiEndpointsMap["auth"]["staffInfo"];

                  Map staffInfo = await api.requestHandler(
                      staffInfoEndpoint.route, staffInfoEndpoint.method, {});

                  bool result = await savingData.LDS(
                    token: uToken,
                    user_id: staffInfo["user_id"],
                    email: staffInfo["email"],
                    name: staffInfo["name"],
                    role: staffInfo['role'],
                    avatar: staffInfo["avatar"],
                    melli_code: staffInfo['melli_code'],
                    personal_code: staffInfo['personal_code'],
                    section: staffInfo["section"],
                    lastLogin: staffInfo["last_login"],
                  );

                  if (result) {
                    localData.refreshToken = uToken;
                    Navigator.pushNamed(context, "/loginCheckout");
                  } else {
                    Toast.show("Your info can not saved", context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM,
                        textColor: Colors.white);
                  }
                }
              } catch (e) {
                print(e);
                setState(() => isConfirm = false);
                showStatusInCaseOfFlush(
                    context: context,
                    title: "خطا در ارسال اطلاعات",
                    msg: "مشکلی در ارتباط با سرویس دهنده رخ داده است",
                    icon: Icons.workspaces_outline,
                    iconColor: Colors.white);
              }
            } else {
              showStatusInCaseOfFlush(
                  context: context,
                  title: notValidPassText,
                  msg: passwordCheckerText,
                  icon: Icons.email,
                  iconColor: Colors.white);
            }
          } else {
            showStatusInCaseOfFlush(
                context: context,
                title: "گذرواژه جدید باید با تکرار آن یکسان باشد",
                msg: "",
                icon: Icons.workspaces_outline,
                iconColor: Colors.white);
          }
        } else {
          showStatusInCaseOfFlush(
              context: context,
              title: "گذرواژه شما باید بیشتر از 6 حرف باشد",
              msg: "",
              icon: Icons.vpn_key_outlined,
              iconColor: Colors.white);
        }
      } else {
        setState(() {
          emptyTextFieldErrPassword = null;
          emptyTextFieldErrRePassword = null;
        });
        rAlert(
            context: context,
            tAlert: AlertType.warning,
            onTapped: () =>
                Navigator.popUntil(context, ModalRoute.withName("/confirm")),
            title: "ورودی اطلاعات برای ثبت ناقص است",
            desc:
                "شما نمی توانید فیلد های مهمی که در این صفحه وجود دارد را خالی رها کنید");
      }
    }

    // Convert Image to base 64 File Image
    void galleryViewer() async {
      /// Getting image file from file user file picker and convert it to base64.
      final pickedImage =
          await ImagePickerWeb.getImage(outputType: ImageType.bytes);

      String _img64 = await convertable.img2Base64(pickedImage);
      setState(() => _image64 = _img64);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          "تکمیل اطلاعات اولیه",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.0.h),
              CircleAvatar(
                radius: circleAvatarRadiusSize,
                backgroundImage: imgSource != null
                    ? FileImage(imgSource)
                    : NetworkImage(userInfo['avatar']),
                child: Container(
                  margin: EdgeInsets.only(top: 100, left: 80),
                  child: ClipOval(
                    child: Material(
                      color: mainSectionCTA, // button color
                      child: InkWell(
                        splashColor: Colors.black, // inkwell color
                        child: SizedBox(
                            width: 40,
                            height: 40,
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
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  changeDefaultPassword,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFields(
                lblText: passwordPlaceHolder,
                keyboardType: TextInputType.visiblePassword,
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
                lblText: passwordPlaceHolderNew,
                maxLen: 20,
                readOnly: false,
                keyboardType: TextInputType.visiblePassword,
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
              SizedBox(height: 2.0.h),
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
              !isConfirm
                  ? gettingLogin(
                      uToken: uToken,
                      curPass: currentPass,
                      pass: password,
                      rePass: rePassword,
                      avatar: _image64)
                  : null;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isConfirm
                    ? CupertinoActivityIndicator()
                    : Text(
                        confirmLogin,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: loginBtnTxtColor,
                            fontFamily: mainFaFontFamily,
                            fontSize: btnSized,
                            fontWeight: FontWeight.normal),
                      ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
