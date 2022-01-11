import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPSubmission extends StatefulWidget {
  const OTPSubmission({Key key}) : super(key: key);

  @override
  _OTPSubmissionState createState() => _OTPSubmissionState();
}

String otpCode;

class _OTPSubmissionState extends State<OTPSubmission> {
  @override
  void initState() {
    otpCode = "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _pinPutController = TextEditingController();
    final FocusNode _pinPutFocusNode = FocusNode();

    BoxDecoration _pinPutDecoration = BoxDecoration(
      border: Border.all(color: mainCTA, width: 2),
      borderRadius: BorderRadius.circular(15.0),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        title: Text(
          "کدی فرستاده ایم",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Lottie.asset(
                "assets/lottie/otp_message_animation.json",
                width: 180,
                height: 180,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 100),
              child: PinPut(
                textStyle: TextStyle(fontFamily: mainFaFontFamily),
                fieldsCount: 4,
                autofocus: true,
                onSubmit: (String pin) => Navigator.pushNamed(
                    context, "/recoverPassword",
                    arguments: pin),
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: _pinPutDecoration.copyWith(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                selectedFieldDecoration: _pinPutDecoration,
                followingFieldDecoration: _pinPutDecoration.copyWith(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: mainCTA, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
