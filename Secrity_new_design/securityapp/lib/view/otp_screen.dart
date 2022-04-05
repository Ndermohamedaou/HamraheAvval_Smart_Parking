import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/ApiAccess.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:securityapp/widgets/alert.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';

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

    // Sent data from forgetPassword.dart with key of {"personalCode"}
    final personalCode = ModalRoute.of(context).settings.arguments as Map;

    BoxDecoration _pinPutDecoration = BoxDecoration(
      border: Border.all(color: mainCTA, width: 2),
      borderRadius: BorderRadius.circular(15.0),
    );

    onSubmitOTPCode(String pin) async {
      ///
      /// In this function we will send otp code and personal code to server
      /// for validating otp code was sent to user at right time.
      ApiAccess api = ApiAccess();
      try {
        final otpCheckResult = await api.checkOTP(
            otpNumber: pin, personalCode: personalCode["personalCode"]);

        if (otpCheckResult == "200")
          Navigator.pushNamed(context, recoverPasswordRoute, arguments: pin);
        else if (otpCheckResult == "500")
          showStatusInCaseOfFlush(
              context: context,
              title: otpCheckFailedTitle,
              msg: otpCheckFailedDesc,
              iconColor: Colors.white,
              icon: Icons.close);
      } catch (e) {
        print(e);
        rAlert(
          context: context,
          tAlert: AlertType.error,
          title: addPlateServerErrorTitle,
          desc: addPlateServerErrorDesc,
          onTapped: () => Navigator.pop(context),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
        title: Text(
          "کدی فرستاده ایم",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFont,
            fontSize: 20,
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
                "assets/animation/otp_message_animation.json",
                width: 180,
                height: 180,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 100),
              child: PinPut(
                textStyle: TextStyle(fontFamily: mainFont, fontSize: 20),
                fieldsCount: 4,
                autofocus: true,
                onSubmit: onSubmitOTPCode,
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
