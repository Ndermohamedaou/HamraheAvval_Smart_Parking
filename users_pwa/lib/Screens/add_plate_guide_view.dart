import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/guide_opetion.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';

class AddPlateGuideView extends StatefulWidget {
  const AddPlateGuideView({Key key}) : super(key: key);

  @override
  _AddPlateGuideViewState createState() => _AddPlateGuideViewState();
}

class _AddPlateGuideViewState extends State<AddPlateGuideView> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          parkingGuideViewAppBar,
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
            SizedBox(height: 20),
            Option(
                themeChange: themeChange,
                text: "$minePlateTitleText\n$minePlateDescText"),
            SizedBox(height: 8),
            Option(
                themeChange: themeChange,
                text: "$familyPlateTitleText\n$familyPlateDscText"),
            SizedBox(height: 8),
            Option(
                themeChange: themeChange,
                text: "$otherPlateText\n$otherPlateDscText"),
          ],
        ),
      ),
    );
  }
}
