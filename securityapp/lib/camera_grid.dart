import 'package:flutter/material.dart';
import 'package:securityapp/constFile/ConstFile.dart';


class CameraGridView extends StatefulWidget {
  @override
  _CameraGridViewState createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("دوربین ها", style: TextStyle(fontFamily: mainFontFamily),),
      ),
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
