import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
    var size = MediaQuery.of(context).size;
    // Change width of Pinput widget to center of the screen if size is larger than 500px.
    final double widthSizedResponse = size.width > 500 ? 300 : double.infinity;

    final TextEditingController _pinPutController = TextEditingController();
    final FocusNode _pinPutFocusNode = FocusNode();

    BoxDecoration _pinPutDecoration = BoxDecoration(
      border: Border.all(color: mainCTA, width: 2),
      borderRadius: BorderRadius.circular(15.0),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          "کدی فرستاده ایم",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.0.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 100),
              // width: widthSizedResponse,
              child: PinPut(
                textStyle:
                    TextStyle(fontFamily: mainFaFontFamily, fontSize: 20),
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
