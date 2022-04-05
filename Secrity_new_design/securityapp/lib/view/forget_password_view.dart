import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import '/constFile/initStrings.dart';
import '/constFile/initVar.dart';
import '/model/ApiAccess.dart';
import '/widgets/bottomBtn.dart';
import '/widgets/flushbarStatus.dart';
import '/widgets/textField.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

String personalCode;
bool _submitPersonalCode;

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  void initState() {
    personalCode = "";
    _submitPersonalCode = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void submitOTP(personalCode) async {
      ApiAccess api = ApiAccess();

      if (personalCode != "") {
        try {
          setState(() => _submitPersonalCode = false);
          final result = await api.passwordReset(personalCode: personalCode);

          if (result == "200") {
            setState(() => _submitPersonalCode = true);
            Navigator.pushNamed(context, otpRoute,
                arguments: {"personalCode": personalCode});
          }
        } catch (e) {
          setState(() => _submitPersonalCode = true);
          print(e);
          showStatusInCaseOfFlush(
              context: context,
              title: wrongPersonalCode,
              msg: wrongPersonalCodeInfo,
              iconColor: Colors.white,
              icon: Icons.close);
          // print("Error from reset password: $e");
        }
      } else
        showStatusInCaseOfFlush(
            context: context,
            title: emptyBox,
            msg: emptyPersonalCode,
            iconColor: Colors.white,
            icon: Icons.close);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
        centerTitle: true,
        title: Text(
          recoverPasswordAppBar,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFont,
            fontSize: 20,
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
                "assets/animation/forget_password_animation.json",
                width: 180,
                height: 180,
              ),
            ),
            TextFields(
                lblText: personalCodeText,
                keyType: TextInputType.emailAddress,
                textFieldIcon: Icons.account_circle,
                textInputType: false,
                readOnly: false,
                onChangeText: (onChangePersonalCode) =>
                    setState(() => personalCode = onChangePersonalCode)),
          ],
        ),
      )),
      bottomNavigationBar: BottomButton(
        text: next,
        color: mainCTA,
        onTapped: () => submitOTP(personalCode),
      ),
    );
  }
}
