import 'package:flutter/material.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/controller/flushbarStatus.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

String personalCode;

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  ApiAccess api = ApiAccess();

  @override
  void initState() {
    personalCode = "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submitOTP(personalCode) async {
    try {
      // final result =
      //     await api.submitOTPPasswordReset(personalCode: personalCode);

      // if (result == "404")
      Navigator.pushNamed(context, "/otpSection");
      // else
      //   showStatusInCaseOfFlush(
      //       context: context,
      //       title: "خطا در شناسه کاربری",
      //       msg: "ممکن است اطلاعات ورود اشتباه یا در سامانه موجود نباشد",
      //       iconColor: Colors.red,
      //       icon: Icons.close);
    } catch (e) {
      // showStatusInCaseOfFlush(
      //     context: context,
      //     title: "خطا در برقراری ارتباط با سرویس دهنده",
      //     msg: "ارتباط خود را بررسی کنید یا با سرویس دهنده در تماس باشید",
      //     iconColor: Colors.red,
      //     icon: Icons.close);
      // print("Error from reset password: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
        centerTitle: true,
        title: Text(
          "بازنشانی گذرواژه حساب شما",
          style:
              TextStyle(fontFamily: mainFaFontFamily, fontSize: subTitleSize),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Lottie.asset(
                "assets/lottie/forget_password_animation.json",
                width: 180,
                height: 180,
              ),
            ),
            TextFields(
                lblText: personalCodePlaceHolder,
                keyboardType: TextInputType.emailAddress,
                textFieldIcon: Icons.account_circle,
                textInputType: false,
                readOnly: false,
                onChangeText: (onChangePers) =>
                    setState(() => personalCode = onChangePers)),
          ],
        ),
      )),
      bottomNavigationBar: BottomButton(
        text: "بعدی",
        ontapped: () => submitOTP(personalCode),
      ),
    );
  }
}
