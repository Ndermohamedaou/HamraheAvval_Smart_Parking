import 'package:flutter/material.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/text_field_controller.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbar_status.dart';
import 'package:payausers/controller/validator/textValidator.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

String currentPassword = "";
String newPassword = "";
String confirmNewPassword = "";
bool validatePassword1 = false;
bool validatePassword2 = false;
IconData showMePass = Icons.remove_red_eye;
dynamic emptyTextFieldErrCurPassword;
dynamic emptyTextFieldErrNewPassword;
dynamic emptyTextFieldErrConfNewPassword;
bool protectedPassword = true;

class ChangePassPage extends StatefulWidget {
  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  @override
  void initState() {
    currentPassword = "";
    newPassword = "";
    confirmNewPassword = "";
    showMePass = Icons.remove_red_eye;
    emptyTextFieldErrCurPassword = null;
    emptyTextFieldErrNewPassword = null;
    emptyTextFieldErrConfNewPassword = null;
    protectedPassword = true;
    validatePassword1 = false;
    validatePassword2 = false;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final localData = Provider.of<AvatarModel>(context);
    ApiAccess api = ApiAccess(localData.userToken);
    // Sending to api
    // ignore: missing_return
    Future<String> sendPassword(currentPassword, newPassword) async {
      Endpoint changePasswordEndpoint =
          apiEndpointsMap["auth"]["changePassword"];

      try {
        final result = await api.requestHandler(
            "${changePasswordEndpoint.route}?current_password=$currentPassword&new_password=$newPassword",
            changePasswordEndpoint.method, {});
        // print(result);
        return result;
      } catch (e) {
        Toast.show(t.translate("global.actions.changeNotEffect"), context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    }

    void changePass({curPass, newPass, confPass}) async {
      if (curPass != "" && newPass != "" && confPass != "") {
        if (newPass.length >= 6 && confPass.length >= 6) {
          // \-- test passwords for complex for with regex
          bool testNewPass = passwordRegex(newPass);
          bool testConfPass = passwordRegex(confPass);
          // print(testNewPass); --/

          if (testNewPass && testConfPass) {
            if (newPass == confPass) {
              final result = await sendPassword(curPass, newPass);
              if (result == "200") {
                Navigator.pop(context);
                Toast.show(
                    t.translate("global.success.changePassword.changePassword"),
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM,
                    textColor: Colors.white);
              } else {
                print(result);
                Toast.show(
                    t.translate(
                        "global.warnings.changePassword.wrongCurrentPassword"),
                    context,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.BOTTOM,
                    textColor: Colors.white);
              }
            } else {
              showStatusInCaseOfFlush(
                  context: context,
                  title: t.translate(
                      "global.warnings.confirmPassword.wrongInCorrespondCheckTitle"),
                  msg: t.translate(
                      "global.warnings.confirmPassword.wrongInCorrespondCheckDesc"),
                  icon: Icons.email,
                  iconColor: Colors.white);
            }
          } else {
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate(
                    "global.warnings.confirmPassword.wrongPasswordCountTitle"),
                msg: t.translate(
                    "global.warnings.confirmPassword.wrongPasswordCountDesc"),
                icon: Icons.email,
                iconColor: Colors.white);
          }
        } else {
          Toast.show(
              t.translate(
                  "global.warnings.confirmPassword.wrongPasswordCountDesc"),
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } else {
        setState(() {
          emptyTextFieldErrCurPassword =
              t.translate("global.info.mustNotEmpty");
          emptyTextFieldErrNewPassword =
              t.translate("global.info.mustNotEmpty");
          emptyTextFieldErrConfNewPassword =
              t.translate("global.info.mustNotEmpty");
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          t.translate("recoverPassword.appBar"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFields(
                lblText: t.translate("recoverPassword.currentPassword"),
                keyboardType: TextInputType.visiblePassword,
                maxLen: 20,
                readOnly: false,
                errText: emptyTextFieldErrCurPassword == null
                    ? null
                    : t.translate("global.info.mustNotEmpty"),
                textInputType: protectedPassword,
                textFieldIcon:
                    currentPassword == "" ? Icons.vpn_key_outlined : showMePass,
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
                    emptyTextFieldErrCurPassword = null;
                    currentPassword = onChangePassword;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFields(
                keyboardType: TextInputType.visiblePassword,
                lblText: t.translate("confirmInfo.fields.newPassword"),
                maxLen: 20,
                readOnly: false,
                errText: emptyTextFieldErrNewPassword == null
                    ? null
                    : t.translate("global.info.mustNotEmpty"),
                textInputType: protectedPassword,
                textFieldIcon:
                    newPassword == "" ? Icons.vpn_key_outlined : showMePass,
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
                    emptyTextFieldErrNewPassword = null;
                    newPassword = onChangePassword;
                    validatePassword1 = passwordRegex(onChangePassword);
                  });
                },
              ),
              newPassword != ""
                  ? validatePassword1
                      ? CustomTextErrorChecker(
                          text: t.translate(
                              "global.success.changePassword.correctPassword"),
                          textColor: Colors.green,
                          icon: Icons.done,
                        )
                      : CustomTextErrorChecker(
                          text: t.translate(
                              "global.warnings.confirmPassword.wrongPasswordCountDesc"),
                          textColor: Colors.red,
                          icon: Icons.close)
                  : SizedBox(),
              SizedBox(height: 10),
              TextFields(
                keyboardType: TextInputType.visiblePassword,
                lblText: t.translate("confirmInfo.fields.confirmNewPassword"),
                maxLen: 20,
                readOnly: false,
                errText: emptyTextFieldErrConfNewPassword == null
                    ? null
                    : t.translate("global.info.mustNotEmpty"),
                textInputType: protectedPassword,
                textFieldIcon: confirmNewPassword == ""
                    ? Icons.vpn_key_outlined
                    : showMePass,
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
                    emptyTextFieldErrConfNewPassword = null;
                    confirmNewPassword = onChangePassword;
                    validatePassword2 = passwordRegex(onChangePassword);
                  });
                },
              ),
              confirmNewPassword != ""
                  ? validatePassword2
                      ? CustomTextErrorChecker(
                          text: t.translate(
                              "global.success.changePassword.correctPassword"),
                          textColor: Colors.green,
                          icon: Icons.done,
                        )
                      : CustomTextErrorChecker(
                          text: t.translate(
                              "global.warnings.confirmPassword.wrongPasswordCountDesc"),
                          textColor: Colors.red,
                          icon: Icons.close,
                        )
                  : SizedBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(16.0),
          color: mainSectionCTA,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () => changePass(
                curPass: currentPassword,
                newPass: newPassword,
                confPass: confirmNewPassword),
            child: Text(
              t.translate("global.info.submitPassword"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: mainFaFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextErrorChecker extends StatelessWidget {
  const CustomTextErrorChecker({Key key, this.text, this.textColor, this.icon})
      : super(key: key);
  final text;
  final textColor;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.centerRight,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          leading: Icon(
            icon,
            color: textColor,
          ),
          title: Text(text,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 15,
                  color: textColor,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
