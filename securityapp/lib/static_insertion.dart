import 'package:flutter/material.dart';
import 'constFile/ConstFile.dart';
import 'titleStyle/titles.dart';

class StaticInsertion extends StatefulWidget {
  @override
  _StaticInsertionState createState() => _StaticInsertionState();
}

class _StaticInsertionState extends State<StaticInsertion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleConfig(
            titleText: "واردکردن دستی اطلاعات",
            textStyles: TextStyle(
              fontSize: fontTitleSize,
              fontFamily: titleFontFamily,
            ),
            titleAlign: TextAlign.center,
          ),
        backgroundColor: appBarBackgroundColor,
      ),
      body: StaticInsertionBody(),
    );
  }
}

class StaticInsertionBody extends StatefulWidget {
  @override
  _StaticInsertionBodyState createState() => _StaticInsertionBodyState();
}

class _StaticInsertionBodyState extends State<StaticInsertionBody> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
