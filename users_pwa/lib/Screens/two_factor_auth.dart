import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/Model/gettingReadyAccount.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:toast/toast.dart';

ApiAccess api;
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

  // Confirmation
  void goToConfirm(token, password) async {
    Endpoint staffInfoEndpoint = apiEndpointsMap["auth"]["staffInfo"];

    try {
      ApiAccess api = ApiAccess(token);
      final userInfo = await api.requestHandler(
          staffInfoEndpoint.route, staffInfoEndpoint.method, {});
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
    GettingReadyAccount gettingReadyAccount = GettingReadyAccount();
    String devToken = "";
    try {
      setState(() async => await FirebaseMessaging.instance.getToken());
    } catch (e) {
      setState(() => devToken = "");
      print(e);
    }

    try {
      setState(() => _isSubmit = true);
      ApiAccess api = ApiAccess("");
      Endpoint submitOTPCode = apiEndpointsMap["auth"]["otp"]["submitCode"];
      final getLoginThirdParty = await api.requestHandler(
          "${submitOTPCode.route}?code=$otpCode&personal_code=$persCode&DeviceToken=$devToken",
          submitOTPCode.method, {});

      if (getLoginThirdParty["status"] == "WrongCodeOrExpired") {
        setState(() => _isSubmit = false);
        showStatusInCaseOfFlush(
            context: context,
            title: "خطا در کد وارد شده",
            msg: "کد وارد شده شما یا منقضی شده است یا اشتباه است",
            iconColor: Colors.white,
            icon: Icons.close);
      }
      if (getLoginThirdParty["status"] == "WrongEmailOrPersonalCode") {
        showStatusInCaseOfFlush(
            context: context,
            title: "خطا در شناسه کاربری",
            msg: "ممکن است اطلاعات ورود اشتباه یا در سامانه موجود نباشد",
            iconColor: Colors.white,
            icon: Icons.close);
      }
      if (getLoginThirdParty["status"] == "200") {
        // Checking First visit
        if (getLoginThirdParty["first_visit"]) {
          goToConfirm(getLoginThirdParty['token'], password);
          setState(() => _isSubmit = false);
        } else {
          gettingReadyAccount.getUserAccInfo(
              getLoginThirdParty['token'], context);
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
          iconColor: Colors.white,
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

  resendCode(String persCode) async {
    setState(() => _start = 60);
    _isRestart = false;
    startTimer();

    ApiAccess api = ApiAccess("");
    Endpoint resendEndpoint = apiEndpointsMap["auth"]["otp"]["resendOTP"];
    try {
      final res = await api.requestHandler(
          "${resendEndpoint.route}?personal_code=$persCode",
          resendEndpoint.method, {});
      print(res);
    } catch (e) {
      print("Erorr of Resend OTP ==> $e");
      showStatusInCaseOfFlush(
          context: context,
          title: "خطا در برقراری ارتباط با سرویس دهنده",
          msg: "ارتباط خود را بررسی کنید یا با سرویس دهنده در تماس باشید",
          iconColor: Colors.white,
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
        backgroundColor: _start != 0 ? defaultAppBarColor : mainSectionCTA,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("وارد کردن کد امنیتی",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: 20,
                color: _start != 0 ? Colors.black : Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                SizedBox(height: 2.0.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 100),
                  child: PinPut(
                    textStyle:
                        TextStyle(fontFamily: mainFaFontFamily, fontSize: 20),
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
