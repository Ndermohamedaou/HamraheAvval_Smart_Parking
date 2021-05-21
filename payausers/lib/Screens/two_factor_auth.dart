import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/SavingData.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:toast/toast.dart';

ApiAccess api = ApiAccess();
Map<String, Object> personalLoginInfo;
String userotpCode = "";
Timer _timer;
var customDuration = Duration(seconds: 1);
int _start = 60;
bool _isRestart = false;
bool _isSubmit = false;

class TwoFactorAuthScreen extends StatefulWidget {
  @override
  _TwoFactorAuthScreenState createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  @override
  void initState() {
    _start = 60;
    userotpCode = "";
    _isSubmit = false;
    _isRestart = false;
    customDuration = Duration(seconds: 1);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    customDuration = Duration(seconds: 1);
    _timer.cancel();
    super.dispose();
  }

  // If user is not new
  void getUserAccInfo(token) async {
    SavingData savingData = SavingData();
    try {
      Map userInfo = await api.getStaffInfo(token: token);
      // Convert plate list from api to lStorage
      // final List userPlates = userInfo["plates"] as List;

      bool result = await savingData.LDS(
        token: token,
        user_id: userInfo["user_id"],
        email: userInfo["email"],
        name: userInfo["name"],
        role: userInfo['role'],
        avatar: userInfo["avatar"],
        melli_code: userInfo['melli_code'],
        personal_code: userInfo['personal_code'],
        section: userInfo["section"],
        lastLogin: userInfo["last_login"],
      );

      if (result) {
        Navigator.pushNamed(context, "/loginCheckout");
      } else {
        Toast.show("Your info can not saved", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    } catch (e) {
      Toast.show("Error in Get User info!", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
    }
  }

  // Confirmation
  void goToConfirm(token, password) async {
    try {
      Map userInfo = await api.getStaffInfo(token: token);
      Navigator.pushNamed(context, "/confirm", arguments: {
        "userInfo": userInfo,
        "curPass": password,
        "token": token
      });
    } catch (e) {
      Toast.show("Can't Confirm you", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
    }
  }

  void checkingOTPReq({otpCode, persCode, password}) async {
    String devToken = "";
    try {
      setState(() async => await FirebaseMessaging.instance.getToken());
    } catch (e) {
      setState(() => devToken = "");
      print(e);
    }

    try {
      setState(() => _isSubmit = true);
      Map getLoginThirdParty = await api.submitOTPCode(
          persCode: persCode, code: otpCode, devToken: devToken);
      print(getLoginThirdParty);

      if (getLoginThirdParty["status"] == "WrongCodeOrExpired") {
        setState(() => _isSubmit = false);
        showStatusInCaseOfFlush(
            context: context,
            title: "خطا در کد وارد شده",
            msg: "کد وارد شده شما یا منقضی شده است یا اشتباه است",
            iconColor: Colors.red,
            icon: Icons.close);
      }
      if (getLoginThirdParty["status"] == "WrongEmailOrPersonalCode") {
        showStatusInCaseOfFlush(
            context: context,
            title: "خطا در شناسه کاربری",
            msg: "ممکن است اطلاعات ورود اشتباه یا در سامانه موجود نباشد",
            iconColor: Colors.red,
            icon: Icons.close);
      }
      if (getLoginThirdParty["status"] == "200") {
        // Checking First visit
        if (getLoginThirdParty["first_visit"]) {
          goToConfirm(getLoginThirdParty['token'], password);
          setState(() => _isSubmit = false);
        } else {
          getUserAccInfo(getLoginThirdParty['token']);
          setState(() => _isSubmit = false);
        }
      }
    } catch (e) {
      print("Erorr of OTP ==> $e");
      setState(() => _isSubmit = false);
      showStatusInCaseOfFlush(
          context: context,
          title: "خطا در برقراری ارتباط با سرویس دهنده",
          msg: "ارتباط خود را بررسی کنید یا با سرویس دهنده در تماس باشید",
          iconColor: Colors.red,
          icon: Icons.close);
    }
  }

  void startTimer() {
    _timer = Timer.periodic(customDuration, (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
          _isRestart = true;
        });
      } else {
        setState(() => _start--);
        if (!mounted) return;
      }
    });
  }

  void resendCode(persCode) async {
    setState(() => _start = 60);
    _isRestart = false;
    startTimer();
    try {
      String res = await api.resendsubmitOTPCode(persCode: persCode);
      print(res);
    } catch (e) {
      print("Erorr of Resend OTP ==> $e");
      showStatusInCaseOfFlush(
          context: context,
          title: "خطا در برقراری ارتباط با سرویس دهنده",
          msg: "ارتباط خود را بررسی کنید یا با سرویس دهنده در تماس باشید",
          iconColor: Colors.red,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    personalLoginInfo = ModalRoute.of(context).settings.arguments;
    final themeChange = Provider.of<DarkThemeProvider>(context);

    final TextEditingController _pinPutController = TextEditingController();
    final FocusNode _pinPutFocusNode = FocusNode();

    BoxDecoration _pinPutDecoration = BoxDecoration(
      border: Border.all(color: mainCTA, width: 2),
      borderRadius: BorderRadius.circular(15.0),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _start != 0 ? mainCTA : mainSectionCTA,
        centerTitle: true,
        // actions: [
        //   FlatButton(
        //       onPressed: () => _isSubmit
        //           ? null
        //           : (userotpCode != "" && userotpCode.length == 4
        //               ? checkingOTPReq(
        //                   otpCode: userotpCode,
        //                   persCode: personalLoginInfo["persCode"],
        //                   password: personalLoginInfo["password"])
        //               : null),
        //       child: _isSubmit
        //           ? Container(
        //               width: 10,
        //               height: 10,
        //               child: CircularProgressIndicator(
        //                 backgroundColor: mainCTA,
        //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //               ),
        //             )
        //           : (userotpCode != "" && userotpCode.length == 4
        //               ? Text(
        //                   "ادامه",
        //                   style: TextStyle(
        //                       fontFamily: mainFaFontFamily,
        //                       fontSize: 18,
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),
        //                 )
        //               : Text(
        //                   "ادامه",
        //                   style: TextStyle(
        //                       fontFamily: mainFaFontFamily,
        //                       color: Colors.black12,
        //                       fontSize: 18,
        //                       fontWeight: FontWeight.bold),
        //                 )))
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                SizedBox(height: 1.0.h),
                Container(
                  alignment: Alignment.topRight,
                  child: Text("ما پیامکی حاوی کد برای شما ارسال کردیم",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 2.0.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 100),
                  child: PinPut(
                    textStyle: TextStyle(fontFamily: mainFaFontFamily),
                    fieldsCount: 4,
                    autofocus: true,
                    onSubmit: (String pin) => checkingOTPReq(
                        otpCode: pin,
                        persCode: personalLoginInfo["persCode"],
                        password: personalLoginInfo["password"]),
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
                // SizedBox(height: 5.0.h),
                // Image.asset(
                //   "assets/images/sms_opt_img.png",
                //   width: 50.0.w,
                // ),

                // SizedBox(height: 5.0.h),
                // Container(
                //   width: 250,
                //   child: TextFields(
                //     lblText: "کد",
                //     cursorColor: _start == 0 ? mainSectionCTA : mainCTA,
                //     borderColor: _start == 0 ? mainSectionCTA : mainCTA,
                //     keyboardType: TextInputType.number,
                //     textFieldIcon: Icons.sms,
                //     textInputType: false,
                //     readOnly: false,
                //     maxLen: 4,
                //     // errText:
                //     //     emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
                //     onChangeText: (onChangeOTPCode) {
                //       setState(() {
                //         userotpCode = onChangeOTPCode;
                //       });
                //     },
                //   ),
                // ),
                SizedBox(height: 5.0.h),
                Container(
                  width: 350,
                  alignment: Alignment.center,
                  child: !_isRestart
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "پیامکی دریافت نکرده اید؟ ",
                              style: TextStyle(
                                  color: themeChange.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: mainFaFontFamily,
                                  fontSize: 19),
                              children: [
                                TextSpan(
                                    text:
                                        "می توانید تا $_start ثانیه دیگر دوباره امتحان کنید",
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        color: mainCTA,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19)),
                              ]),
                        )
                      : GestureDetector(
                          onTap: () =>
                              resendCode(personalLoginInfo["persCode"]),
                          child: Text("ارسال مجدد کد",
                              style: TextStyle(
                                  fontFamily: mainFaFontFamily,
                                  color: mainSectionCTA,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19)),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
