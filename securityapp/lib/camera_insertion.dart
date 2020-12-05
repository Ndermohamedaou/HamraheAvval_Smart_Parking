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
    );
  }
}

class CameraInsertionBody extends StatefulWidget {
  @override
  _CameraInsertionBodyState createState() => _CameraInsertionBodyState();
}

class _CameraInsertionBodyState extends State<CameraInsertionBody> {
  Map<String, Object> img;

  Future sendingImage(rawImage)async{
  // TODO: Next of getting API
  }

  Future convertingImg(imgFile) async {
    // print(imgFile['img']);
    // TODO do some config and pass raw image file to sendingImage()
  }

  @override
  Widget build(BuildContext context) {
    // To get img from right side
    img = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Image.file(img['img']),
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 40),
                    child: RawMaterialButton(
                      onPressed: () {
                        convertingImg(img);
                      },
                      elevation: 2.0,
                      fillColor: Colors.blue,
                      child: Icon(
                        CupertinoIcons.capslock_fill,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      padding: EdgeInsets.all(18.0),
                      shape: CircleBorder(),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
