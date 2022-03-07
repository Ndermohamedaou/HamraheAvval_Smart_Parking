import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/validator/textValidator.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({
    Key key,
  }) : super(key: key);

  @override
  RecoverPasswordState createState() => RecoverPasswordState();
}

IconData showMePass;
bool protectedPassword;
String password;
String rePassword;
String otpCode;
bool _isSubmit;
dynamic emptyPassCheck = null;
dynamic emptyRepassCheck = null;
ApiAccess api;

class RecoverPasswordState extends State<RecoverPassword> {
  @override
  void initState() {
    showMePass = Icons.remove_red_eye;
    protectedPassword = true;
    password = "";
    rePassword = "";
    otpCode = "";
    _isSubmit = true;
    emptyPassCheck = null;
    emptyRepassCheck = null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    // Getting user token from local storage.
    final localData = Provider.of<AvatarModel>(context);
    // Passing user token to api.
    api = ApiAccess(localData.userToken);
    otpCode = ModalRoute.of(context).settings.arguments;
    // print("Your otp code : $otpCode");

    void submitPassword({otpCode, String pass, String repass}) async {
      try {
        if (pass != "" && repass != "") {
          if (pass.length >= 6 && repass.length >= 6) {
            if (pass == repass) {
              bool testRegexPass = passwordRegex(pass);
              bool testRegexRePass = passwordRegex(repass);
              if (testRegexPass && testRegexRePass) {
                setState(() => _isSubmit = false);
                Endpoint otpEndpoint =
                    apiEndpointsMap["auth"]["otp"]["recoverPassword"];
                print("${otpEndpoint.route}?otp_code=$otpCode&password=$pass");

                final recoverPasswordResult = await api.requestHandler(
                    "${otpEndpoint.route}?otp_code=$otpCode&password=$pass",
                    otpEndpoint.method, {});

                print("${otpEndpoint.route}?otp_code=$otpCode&password=$pass");

                if (recoverPasswordResult == "200") {
                  setState(() => _isSubmit = true);
                  // Pop on Login Route
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 3;
                  });
                  showStatusInCaseOfFlush(
                      context: context,
                      title: t.translate("global.success.recoverPassword"),
                      msg: t.translate("global.success.recoverPasswordDesc"),
                      mainBackgroundColor: "#00c853",
                      iconColor: Colors.white,
                      icon: Icons.done_all_rounded);
                } else {
                  showStatusInCaseOfFlush(
                      context: context,
                      title: t.translate("otp.wrongOTPTitle"),
                      msg: t.translate("otp.wrongOTPDesc"),
                      iconColor: Colors.white,
                      icon: Icons.close);
                }
              } else {
                setState(() => _isSubmit = true);

                showStatusInCaseOfFlush(
                    context: context,
                    title: t.translate("global.errors.invalidPassword"),
                    msg: t.translate("global.errors.passwordCheckerText"),
                    icon: Icons.email,
                    iconColor: Colors.white);
              }
            } else {
              setState(() => _isSubmit = true);
              showStatusInCaseOfFlush(
                  context: context,
                  title: t.translate("global.errors.passwordsNotMatchTitle"),
                  msg: t.translate("global.errors.passwordsNotMatchDesc"),
                  iconColor: Colors.white,
                  icon: Icons.close);
            }
          } else {
            setState(() => _isSubmit = true);
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate(
                    "global.warnings.confirmPassword.wrongPasswordCountTitle"),
                msg: t.translate(
                    "global.warnings.confirmPassword.wrongPasswordCountDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
          }
        } else {
          setState(() => _isSubmit = true);
          setState(() {
            emptyPassCheck = t.translate("global.info.mustNotEmpty");
            emptyRepassCheck = t.translate("global.info.mustNotEmpty");
          });
          showStatusInCaseOfFlush(
              context: context,
              title: t.translate("global.info.mustNotEmpty"),
              msg: t.translate("global.info.enterPassword"),
              iconColor: Colors.white,
              icon: Icons.close);
        }
      } catch (e) {
        print("Error from reset password: $e");
        setState(() => _isSubmit = true);
        showStatusInCaseOfFlush(
            context: context,
            title: t.translate("global.errors.serverError"),
            msg: t.translate("global.errors.connectionFailed"),
            iconColor: Colors.white,
            icon: Icons.close);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName("/login"));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: defaultAppBarColor,
          title: Text(
            t.translate("recoverPassword.appBar"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.0.h),
              TextFields(
                lblText: t.translate("login.fields.password"),
                maxLen: 20,
                keyboardType: TextInputType.visiblePassword,
                readOnly: false,
                textInputType: protectedPassword,
                errText: emptyPassCheck == null
                    ? null
                    : t.translate("global.info.mustNotEmpty"),
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
                onChangeText: (onChangePass) => setState(
                  () {
                    password = onChangePass;
                    emptyPassCheck = null;
                  },
                ),
              ),
              SizedBox(height: 2.0.h),
              TextFields(
                lblText: t.translate("login.newPassword"),
                maxLen: 20,
                keyboardType: TextInputType.visiblePassword,
                readOnly: false,
                textInputType: protectedPassword,
                errText: emptyRepassCheck == null
                    ? null
                    : t.translate("global.info.mustNotEmpty"),
                textFieldIcon:
                    rePassword == "" ? Icons.vpn_key_outlined : showMePass,
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
                onChangeText: (onChangeRepass) => setState(
                  () {
                    rePassword = onChangeRepass;
                    emptyRepassCheck = null;
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomButton(
          text: t.translate("recoverPassword.submitChanges"),
          hasCondition: _isSubmit,
          onTapped: () => submitPassword(
              otpCode: otpCode, pass: password, repass: rePassword),
        ),
      ),
    );
  }
}
