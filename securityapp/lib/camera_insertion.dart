import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'constFile/ConstFile.dart';
import 'titleStyle/titles.dart';

HexColor backPanelColor = HexColor('#1a2e48');

class CameraInsertion extends StatefulWidget {
  @override
  _CameraInsertionState createState() => _CameraInsertionState();
}

class _CameraInsertionState extends State<CameraInsertion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleConfig(
          titleText: "تایید تصویر",
          textStyles: TextStyle(
            fontSize: fontTitleSize,
            fontFamily: titleFontFamily,
          ),
          titleAlign: TextAlign.center,
        ),
        backgroundColor: appBarBackgroundColor,
      ),
      body: CameraInsertionBody(),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue[900],
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {},
            child: Text(
              'ارسال تصوير',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: loginTextFontFamily,
                  fontSize: loginTextSize,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class CameraInsertionBody extends StatefulWidget {
  @override
  _CameraInsertionBodyState createState() => _CameraInsertionBodyState();
}

class _CameraInsertionBodyState extends State<CameraInsertionBody> {
  Map<String, Object> source;

  Future sendingImage(rawImage) async {
    // TODO: Next of getting API
  }

  Future convertingImg(imgFile) async {
    // print(imgFile['img']);
    // TODO do some config and pass raw image file to sendingImage()
  }

  @override
  Widget build(BuildContext context) {
    // To get img from right side
    source = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              source['img'],
              width: double.infinity,
              scale: 2.5,
            )
          ],
        ),
      ),
    );
  }
}
