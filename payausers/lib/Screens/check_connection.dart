import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CheckConnection extends StatefulWidget {
  const CheckConnection({Key key}) : super(key: key);

  @override
  _CheckConnectionState createState() => _CheckConnectionState();
}

class _CheckConnectionState extends State<CheckConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/connection.png",
                width: 85.0.w,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: CustomText(
                text: connectionErrorTitle,
                size: titleTextSize,
                weight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 4.0.h,
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: mainCTA,
          child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () => Navigator.pushNamed(context, '/splashScreen'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: tryAgainConnectionErrorSubtitle,
                    color: Colors.white,
                    size: 20.0,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
