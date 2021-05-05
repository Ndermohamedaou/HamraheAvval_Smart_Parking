import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/SavingData.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/controller/changeAvatar.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/validator/textValidator.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

Map<String, Object> userInfo;
Map<String, Object> modalRoute;

File imgSource;
String password = "";
String rePassword = "";
dynamic emptyTextFieldErrEmailCode = null;
dynamic emptyTextFieldErrEmail = null;
dynamic emptyTextFieldErrPassword = null;
dynamic emptyTextFieldErrRePassword = null;
ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();
SavingData savingData = SavingData();
ImageConvetion imgConvertor = ImageConvetion();

IconData showMePass = Icons.remove_red_eye;
bool protectedPassword = true;

// Is okay i go to confirm for 1st
bool isConfirm = false;

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
    emptyTextFieldErrEmailCode = null;
    emptyTextFieldErrEmail = null;
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Getting Arguments from login page all about user info.
    modalRoute = ModalRoute.of(context).settings.arguments;

    userInfo = modalRoute["userInfo"];
    final currentPass = modalRoute["curPass"];
    final uToken = modalRoute["token"];

    // print(userInfo);

    void gettingLogin({uToken, curPass, pass, rePass, avatar}) async {
      final _img64 = await imgConvertor.img2Base64(avatar);
      if (pass != "" && rePass != "") {
        if (pass.length > 6 && rePass.length > 6) {
          if (pass == rePass) {
            bool testPass = passwordRegex(pass);
            bool testRePass = passwordRegex(rePass);

            if (testPass && testRePass) {
              try {
                setState(() => isConfirm = true);
                final result = await api.updateStaffInfoInConfrimation(
                    token: uToken,
                    curPass: curPass,
                    newPass: pass,
                    avatar: _img64);
                if (result == "200") {
                  // Saving data to local
                  Map staffInfo = await api.getStaffInfo(token: uToken);
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
                    Navigator.pushNamed(context, "/loginCheckout");
                  } else {
                    Toast.show("Your info can not saved", context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM,
                        textColor: Colors.white);
                  }
                }
              } catch (e) {
                setState(() => isConfirm = false);
                showStatusInCaseOfFlush(
                    context: context,
                    title: "",
                    msg: e.toString(),
                    icon: Icons.workspaces_outline,
                    iconColor: Colors.red);
              }
            } else {
              showStatusInCaseOfFlush(
                  context: context,
                  title: notValidPassText,
                  msg: passwordCheckerText,
                  icon: Icons.email,
                  iconColor: Colors.deepOrange);
            }
          } else {
            showStatusInCaseOfFlush(
                context: context,
                title: "گذرواژه جدید باید با تکرار آن یکسان باشد",
                msg: "",
                icon: Icons.workspaces_outline,
                iconColor: Colors.red);
          }
        } else {
          showStatusInCaseOfFlush(
              context: context,
              title: "گذرواژه شما باید بیشتر از 6 حرف باشد",
              msg: "",
              icon: Icons.vpn_key_outlined,
              iconColor: Colors.yellow.shade800);
        }
      } else {
        setState(() {
          emptyTextFieldErrEmailCode = null;
          emptyTextFieldErrEmail = null;
          emptyTextFieldErrPassword = null;
          emptyTextFieldErrRePassword = null;
        });
        alert(
            context: context,
            themeChange: themeChange,
            aType: AlertType.warning,
            dstRoute: "confirm",
            title: "ورودی اطلاعات برای ثبت ناقص است",
            desc:
                "شما نمی توانید فیلد های مهمی که در این صفحه وجود دارد را خالی رها کنید");
      }
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
              MaterialButton(
                onPressed: () =>
                    Navigator.pushNamed(context, "/addingPlateIntro"),
                color: mainSectionCTA,
                child: Text(
                  "اولین پلاک را در حساب خود وارد کنید",
                  style: TextStyle(
                      fontFamily: mainFaFontFamily, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 30),
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
                lblText: passwordPlaceHolderNew,
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
                        avatar: imgSource)
                    : null;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isConfirm
                      ? Container(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            backgroundColor: mainCTA,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
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
