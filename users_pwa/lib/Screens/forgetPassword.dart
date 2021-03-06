import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              child: TextFields(
                  lblText: personalCodePlaceHolder,
                  keyboardType: TextInputType.emailAddress,
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
        color: mainCTA,
        text: "بعدی",
        onTapped: () => submitOTP(personalCode),
      ),
    );
  }
}
