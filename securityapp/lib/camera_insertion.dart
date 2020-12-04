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
  @override
  Widget build(BuildContext context) {
    // To get img from right side
    final Map<String, Object> img = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: cardStyleColor,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                alignment: Alignment.center,
                child: Image.file(
                  img['img'],
                  scale: 4,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: RaisedButton(
                  onPressed: () {},
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: Text(
                        "تصویر انتقال یابد؟",
                        style: TextStyle(fontFamily: 'BYekan', fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      leading: Icon(
                        Icons.info,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
