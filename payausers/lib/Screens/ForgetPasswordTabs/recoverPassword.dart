import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/validator/textValidator.dart';
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
String repassword;
String otpCode;
bool _isSubmit;
dynamic emptyPassCheck = null;
dynamic emptyRepassCheck = null;

class RecoverPasswordState extends State<RecoverPassword> {
  ApiAccess api = ApiAccess();
  @override
  void initState() {
    showMePass = Icons.remove_red_eye;
    protectedPassword = true;
    password = "";
    repassword = "";
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

  void submitPassword({otpCode, String pass, String repass}) async {
    // print(otpCode);
    // print(password);
    // print(repassword);
    try {
      if (pass != "" && repass != "") {
        if (pass.length >= 6 && repass.length >= 6) {
          if (pass == repass) {
            bool testRegexPass = passwordRegex(pass);
            bool testRegexRePass = passwordRegex(repass);
            if (testRegexPass && testRegexRePass) {
              setState(() => _isSubmit = false);

              final recoverPasswordResult = await api.recoverUserPassword(
                  otpCode: otpCode, password: pass);

              if (recoverPasswordResult == "200") {
                setState(() => _isSubmit = true);
                // Pop on Login Route
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 3;
                });
                showStatusInCaseOfFlush(
                    context: context,
                    title: "عملیات تغییر گذرواژه موفقیت آمیز بود",
                    msg:
                        "گذرواژه شما با موفقیت تغییر کرد، لطفا دوباره اقدام به ورود کنید",
                    iconColor: Colors.green,
                    icon: Icons.done_all_rounded);
              } else {
                showStatusInCaseOfFlush(
                    context: context,
                    title: "خطا در کد وارد شده",
                    msg:
                        "لطفا از صحت کد اطمینان حاصل کنید یا دوباره اقدام کنید",
                    iconColor: Colors.red,
                    icon: Icons.close);
              }
            } else {
              setState(() => _isSubmit = true);

              showStatusInCaseOfFlush(
                  context: context,
                  title: notValidPassText,
                  msg: passwordCheckerText,
                  icon: Icons.email,
                  iconColor: Colors.deepOrange);
            }
          } else {
            setState(() => _isSubmit = true);
            showStatusInCaseOfFlush(
                context: context,
                title: "ناهمسان بودن گذرواژه ها",
                msg: notMatch,
                iconColor: Colors.red,
                icon: Icons.close);
          }
        } else {
          setState(() => _isSubmit = true);
          showStatusInCaseOfFlush(
              context: context,
              title: "تعداد کارکتر های گذرواژه شما کافی نیست",
              msg: notEnouthLen,
              iconColor: Colors.red,
              icon: Icons.close);
        }
      } else {
        setState(() => _isSubmit = true);
        setState(() {
          emptyPassCheck = emptyTextFieldMsg;
          emptyRepassCheck = emptyTextFieldMsg;
        });
        showStatusInCaseOfFlush(
            context: context,
            title: "فیلد گذرواژه ها خالی است",
            msg: "لطفا گذرواژه مورد نظر را وارد نمایید",
            iconColor: Colors.red,
            icon: Icons.close);
      }
    } catch (e) {
      setState(() => _isSubmit = true);
      showStatusInCaseOfFlush(
          context: context,
          title: "خطا در برقراری ارتباط با سرویس دهنده",
          msg: "ارتباط خود را بررسی کنید یا با سرویس دهنده در تماس باشید",
          iconColor: Colors.red,
          icon: Icons.close);
      print("Error from reset password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    otpCode = ModalRoute.of(context).settings.arguments;
    print("Your otp code : $otpCode");
    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(context, ModalRoute.withName("/login"));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: defaultAppBarColor,
          title: Text(
            "ویرایش گذرواژه",
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.0.h),
              TextFields(
                  lblText: passwordPlaceHolder,
                  maxLen: 20,
                  keyboardType: TextInputType.visiblePassword,
                  readOnly: false,
                  textInputType: protectedPassword,
                  errText: emptyPassCheck == null ? null : emptyTextFieldMsg,
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
                  onChangeText: (onChangePass) => setState(() {
                        password = onChangePass;
                        emptyPassCheck = null;
                      })),
              SizedBox(height: 2.0.h),
              TextFields(
                  lblText: passwordPlaceHolderNew,
                  maxLen: 20,
                  keyboardType: TextInputType.visiblePassword,
                  readOnly: false,
                  textInputType: protectedPassword,
                  errText: emptyRepassCheck == null ? null : emptyTextFieldMsg,
                  textFieldIcon:
                      repassword == "" ? Icons.vpn_key_outlined : showMePass,
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
                  onChangeText: (onChangeRepass) => setState(() {
                        repassword = onChangeRepass;
                        emptyRepassCheck = null;
                      }))
            ],
          ),
        ),
        bottomNavigationBar: BottomButton(
          text: "تایید ویرایش گذرواژه",
          hasCondition: _isSubmit,
          ontapped: () => submitPassword(
              otpCode: otpCode, pass: password, repass: repassword),
        ),
      ),
    );
  }
}
