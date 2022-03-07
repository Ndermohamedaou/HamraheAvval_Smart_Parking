import 'package:flutter/material.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ExtractedWidgets/bottom_btn_navigator.dart';
import 'package:payausers/ExtractedWidgets/text_field_controller.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbar_status.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

String personalCode;
bool _submitPersonalCode;

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  ApiAccess api;

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
    AppLocalizations t = AppLocalizations.of(context);
    final localData = Provider.of<AvatarModel>(context);
    api = ApiAccess(localData.userToken);

    void submitOTP(personalCode) async {
      if (personalCode != "") {
        try {
          setState(() => _submitPersonalCode = false);
          Endpoint passwordResetEndpoint =
              apiEndpointsMap["auth"]["otp"]["PasswordReset"];

          final result = await api.requestHandler(
              "${passwordResetEndpoint.route}?personal_code=$personalCode",
              passwordResetEndpoint.method, {});

          if (result == "200") {
            setState(() => _submitPersonalCode = true);
            Navigator.pushNamed(context, "/otpSection",
                arguments: {"personalCode": personalCode});
          }
        } catch (e) {
          setState(() => _submitPersonalCode = true);
          print(e);
          showStatusInCaseOfFlush(
              context: context,
              title: t.translate("recoverPassword.wrongPersonalCode"),
              msg: t.translate("recoverPassword.wrongPersonalCodeInfo"),
              iconColor: Colors.white,
              icon: Icons.close);
          // print("Error from reset password: $e");
        }
      } else
        showStatusInCaseOfFlush(
            context: context,
            title: t.translate("global.warnings.emptyBox"),
            msg: t.translate("recoverPassword.emptyPersonalCode"),
            iconColor: Colors.white,
            icon: Icons.close);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          t.translate("recoverPassword.recoverPasswordAppBar"),
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
                lblText: t.translate("login.fields.personalCode"),
                keyboardType: TextInputType.emailAddress,
                textFieldIcon: Icons.account_circle,
                textInputType: false,
                readOnly: false,
                onChangeText: (onChangePersonalCode) =>
                    setState(() => personalCode = onChangePersonalCode)),
          ],
        ),
      )),
      bottomNavigationBar: BottomButton(
        text: t.translate("navigation.next"),
        onTapped: () => submitOTP(personalCode),
      ),
    );
  }
}
