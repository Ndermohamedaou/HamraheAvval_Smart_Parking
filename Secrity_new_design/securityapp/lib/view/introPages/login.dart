import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/textField.dart';
import 'package:sizer/sizer.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({
    this.personalCode,
    this.password,
    this.showMePass,
    this.protectedPassword,
  });

  final personalCode;
  final password;
  final showMePass;
  final protectedPassword;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5.0.h),
            Image.asset(
              "assets/images/Titile_Logo_Mark.png",
              width: 50.0.w,
            ),
            SizedBox(height: 8.0.h),
            TextFields(
              keyType: TextInputType.emailAddress,
              lblText: personalCodeText,
              textFieldIcon: Icons.account_circle,
              textInputType: false,
              readOnly: false,
              // errText:
              //     emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
              onChangeText: (onChangeUsername) {
                // setState(() {
                //   // emptyTextFieldErrPersonalCode = null;
                //   username = onChangeUsername;
                // });
              },
            ),
            SizedBox(height: 3.0.h),
            TextFields(
              lblText: passwordCodeText,
              keyType: TextInputType.emailAddress,
              maxLen: 20,
              readOnly: false,
              // errText: emptyTextFieldErrPassword == null
              //     ? null
              //     : emptyTextFieldMsg,
              textInputType: protectedPassword,
              textFieldIcon:
                  password == "" ? Icons.vpn_key_outlined : showMePass,
              iconPressed: () {
                // setState(() {
                //   protectedPassword
                //       ? protectedPassword = false
                //       : protectedPassword = true;
                //   // Changing eye icon pressing
                //   showMePass == Icons.remove_red_eye
                //       ? showMePass = Icons.remove_red_eye_outlined
                //       : showMePass = Icons.remove_red_eye;
                // });
              },
              onChangeText: (onChangePassword) {
                // setState(() {
                //   // emptyTextFieldErrPassword = null;
                //   password = onChangePassword;
                // });
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    text: forgetPassword,
                    size: 11.0.sp,
                    color: mainCTA,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.lock,
                    color: mainCTA,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
