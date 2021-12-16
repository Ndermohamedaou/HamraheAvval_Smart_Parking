import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
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
bool _submitPers;

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  ApiAccess api = ApiAccess();

  @override
  void initState() {
    personalCode = "";
    _submitPers = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submitOTP(personalCode) async {
    if (personalCode != "") {
      try {
        setState(() => _submitPers = false);
        final result =
            await api.submitOTPPasswordReset(personalCode: personalCode);

        if (result == "200") {
          setState(() => _submitPers = true);
          Navigator.pushNamed(context, "/otpSection");
        }
      } catch (e) {
        setState(() => _submitPers = true);
        showStatusInCaseOfFlush(
            context: context,
            title: "خطا در شناسه کاربری",
            msg: "ممکن است اطلاعات ورود اشتباه یا در سامانه موجود نباشد",
            iconColor: Colors.red,
            icon: Icons.close);
        print("Error from reset password: $e");
      }
    } else
      showStatusInCaseOfFlush(
          context: context,
          title: "فیلد خالی",
          msg: "فیلد کدپرسنلی نمیتواند خالی رها شود",
          iconColor: Colors.red,
          icon: Icons.close);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("بازنشانی گذرواژه حساب شما",
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
            )),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: TextFields(
                  lblText: personalCodePlaceHolder,
                  keyType: TextInputType.emailAddress,
                  textFieldIcon: Icons.account_circle,
                  textInputType: false,
                  readOnly: false,
                  onChangeText: (onChangePers) =>
                      setState(() => personalCode = onChangePers)),
            ),
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
