import 'package:flutter/material.dart';
import 'package:securityapp/widgets/textField.dart';
import 'package:sizer/sizer.dart';

class Password extends StatelessWidget {
  const Password({
    this.pass,
    this.onChangePass,
    this.rePass,
    this.onChangeRePass,
    this.passIconPressed,
    this.protectedPassword,
    this.showMePass,
  });

  final pass;
  final Function onChangePass;
  final rePass;
  final Function onChangeRePass;
  final Function passIconPressed;
  final protectedPassword;
  final showMePass;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10.0.h),
          Image.asset(
            "assets/images/privacy.png",
            width: 120.0.w,
            height: 40.0.h,
          ),
          TextFields(
            initValue: pass,
            lblText: "گذرواژه",
            keyType: TextInputType.text,
            maxLen: 20,
            readOnly: false,
            textInputType: protectedPassword,
            textFieldIcon: pass == "" ? Icons.vpn_key_outlined : showMePass,
            iconPressed: passIconPressed,
            onChangeText: onChangePass,
          ),
          SizedBox(height: 20),
          TextFields(
            initValue: rePass,
            lblText: "تکرار گذرواژه",
            keyType: TextInputType.text,
            maxLen: 20,
            readOnly: false,
            textInputType: protectedPassword,
            textFieldIcon: pass == "" ? Icons.vpn_key_outlined : showMePass,
            iconPressed: passIconPressed,
            onChangeText: onChangeRePass,
          ),
        ],
      ),
    );
  }
}
