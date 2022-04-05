import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/ApiAccess.dart';
import 'package:securityapp/validator/regex.dart';
import 'package:securityapp/widgets/bottomBtn.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:securityapp/widgets/textField.dart';
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
dynamic emptyPassCheck;
dynamic emptyRepassCheck;

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
    otpCode = ModalRoute.of(context).settings.arguments;
    // print("Your otp code : $otpCode");

    void submitPassword({otpCode, String pass, String repass}) async {
      ApiAccess api = ApiAccess();
      try {
        if (pass != "" && repass != "") {
          if (pass.length >= 6 && repass.length >= 6) {
            if (pass == repass) {
              bool testRegexPass = passwordRegex(pass);
              bool testRegexRePass = passwordRegex(repass);
              if (testRegexPass && testRegexRePass) {
                setState(() => _isSubmit = false);

                final recoverPasswordResult = await api.recoverPassword(
                    otpCode: otpCode, password: password);

                if (recoverPasswordResult == "200") {
                  setState(() => _isSubmit = true);
                  // Pop on Login Route
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 3;
                  });
                  showStatusInCaseOfFlush(
                      context: context,
                      title: recoverPasswordTitle,
                      msg: recoverPasswordDesc,
                      iconColor: Colors.white,
                      icon: Icons.done_all_rounded);
                } else {
                  showStatusInCaseOfFlush(
                      context: context,
                      title: wrongOTPTitle,
                      msg: wrongOTPDesc,
                      iconColor: Colors.white,
                      icon: Icons.close);
                }
              } else {
                setState(() => _isSubmit = true);

                showStatusInCaseOfFlush(
                    context: context,
                    title: invalidPassword,
                    msg: passwordCheckerText,
                    icon: Icons.email,
                    iconColor: Colors.white);
              }
            } else {
              setState(() => _isSubmit = true);
              showStatusInCaseOfFlush(
                  context: context,
                  title: passwordsNotMatchTitle,
                  msg: passwordsNotMatchDesc,
                  iconColor: Colors.white,
                  icon: Icons.close);
            }
          } else {
            setState(() => _isSubmit = true);
            showStatusInCaseOfFlush(
                context: context,
                title: wrongPasswordCountTitle,
                msg: wrongPasswordCountDesc,
                iconColor: Colors.white,
                icon: Icons.close);
          }
        } else {
          setState(() => _isSubmit = true);
          setState(() {
            emptyPassCheck = mustNotEmpty;
            emptyRepassCheck = mustNotEmpty;
          });
          showStatusInCaseOfFlush(
              context: context,
              title: mustNotEmpty,
              msg: enterPassword,
              iconColor: Colors.white,
              icon: Icons.close);
        }
      } catch (e) {
        print("Error from reset password: $e");
        setState(() => _isSubmit = true);
        showStatusInCaseOfFlush(
            context: context,
            title: serverError,
            msg: connectionFailed,
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
          backgroundColor: mainCTA,
          title: Text(
            recoverPasswordAppBar,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFont,
              fontSize: 22,
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
                lblText: password,
                maxLen: 20,
                keyType: TextInputType.visiblePassword,
                readOnly: false,
                textInputType: protectedPassword,
                errText: emptyPassCheck == null ? null : mustNotEmpty,
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
                lblText: newPassword,
                maxLen: 20,
                keyType: TextInputType.visiblePassword,
                readOnly: false,
                textInputType: protectedPassword,
                errText: emptyRepassCheck == null ? null : mustNotEmpty,
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
          text: savedSuccessBtn,
          onTapped: () => submitPassword(
              otpCode: otpCode, pass: password, repass: rePassword),
        ),
      ),
    );
  }
}
