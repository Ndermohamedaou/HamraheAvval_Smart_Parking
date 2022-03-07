import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
    AppLocalizations t = AppLocalizations.of(context);
    // Getting Data of user and parse user token
    final localData = Provider.of<AvatarModel>(context);
    ApiAccess api = ApiAccess(localData.userToken);

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

      Endpoint otpCheckEndpoint = apiEndpointsMap["auth"]["otp"]["checkOTP"];
      try {
        final otpCheckResult = await api.requestHandler(
            "${otpCheckEndpoint.route}?personal_code=${personalCode["personalCode"]}&otp_code=$pin",
            otpCheckEndpoint.method, {});

        print(otpCheckResult);
        print(
            "${otpCheckEndpoint.route}?personal_code=${personalCode["personalCode"]}&otp_code=$pin");

        if (otpCheckResult == "200")
          Navigator.pushNamed(context, "/recoverPassword", arguments: pin);
        else if (otpCheckResult == "500")
          showStatusInCaseOfFlush(
              context: context,
              title: t.translate("otp.otpCheckFailedTitle"),
              msg: t.translate("otp.otpCheckFailedDesc"),
              mainBackgroundColor: "#F38137",
              iconColor: Colors.white,
              icon: Icons.close);
      } catch (e) {
        print(e);
        rAlert(
          context: context,
          tAlert: AlertType.error,
          title: t.translate("global.errors.serverError"),
          desc: t.translate("global.errors.connectionError"),
          onTapped: () => Navigator.pop(context),
        );
      }
    }

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
                textStyle:
                    TextStyle(fontFamily: mainFaFontFamily, fontSize: 20),
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
