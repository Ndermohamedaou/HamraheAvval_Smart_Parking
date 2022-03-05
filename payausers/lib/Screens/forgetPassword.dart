import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

String personalCode;
bool _submitPers;

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  ApiAccess api;

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
        Endpoint passwordResetEndpoint =
            apiEndpointsMap["auth"]["otp"]["PasswordReset"];

        final result = await api.requestHandler(
            "${passwordResetEndpoint.route}?personal_code=$personalCode",
            passwordResetEndpoint.method, {});

        if (result == "200") {
          setState(() => _submitPers = true);
          Navigator.pushNamed(context, "/otpSection",
              arguments: {"personalCode": personalCode});
        }
      } catch (e) {
        setState(() => _submitPers = true);
        print(e);
        showStatusInCaseOfFlush(
            context: context,
            title: "خطا در شناسه کاربری",
            msg: "ممکن است اطلاعات ورود اشتباه یا در سامانه موجود نباشد",
            iconColor: Colors.white,
            icon: Icons.close);
        print("Error from reset password: $e");
      }
    } else
      showStatusInCaseOfFlush(
          context: context,
          title: "فیلد خالی",
          msg: "فیلد کدپرسنلی نمیتواند خالی رها شود",
          iconColor: Colors.white,
          icon: Icons.close);
  }

  @override
  Widget build(BuildContext context) {
    final localData = Provider.of<AvatarModel>(context);
    api = ApiAccess(localData.userToken);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          "بازنشانی گذرواژه حساب شما",
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
        onTapped: () => submitOTP(personalCode),
      ),
    );
  }
}
