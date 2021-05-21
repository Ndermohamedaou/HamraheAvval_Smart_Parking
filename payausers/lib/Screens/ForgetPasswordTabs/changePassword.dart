import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:sizer/sizer.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key key,
  }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

IconData showMePass;
bool protectedPassword;
String password;
String repassword;
String otpCode;

class _ChangePasswordState extends State<ChangePassword> {
  @override
  void initState() {
    showMePass = Icons.remove_red_eye;
    protectedPassword = true;
    password = "";
    repassword = "";
    otpCode = "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submitPassword({otpCode, password, repassword}) async {
    print(otpCode);
    print(password);
    print(repassword);
  }

  @override
  Widget build(BuildContext context) {
    otpCode = ModalRoute.of(context).settings.arguments;
    print("Your otp code : $otpCode");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
        centerTitle: true,
        title: Text(
          "ویرایش گذرواژه",
          style:
              TextStyle(fontFamily: mainFaFontFamily, fontSize: subTitleSize),
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
                onChangeText: (onChangePass) =>
                    setState(() => password = onChangePass)),
            SizedBox(height: 2.0.h),
            TextFields(
                lblText: passwordPlaceHolderNew,
                maxLen: 20,
                keyboardType: TextInputType.visiblePassword,
                readOnly: false,
                textInputType: protectedPassword,
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
                onChangeText: (onChangeRepass) =>
                    setState(() => repassword = onChangeRepass))
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        text: "تایید ویرایش گذرواژه",
        ontapped: () => submitPassword(
            otpCode: otpCode, password: password, repassword: repassword),
      ),
    );
  }
}
