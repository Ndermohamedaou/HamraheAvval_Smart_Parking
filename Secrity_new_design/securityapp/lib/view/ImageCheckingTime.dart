import 'dart:io';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/sentSituation.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/widgets/capturingButton.dart';

Map<dynamic, dynamic> imgSent;
File img;

class ImageChecking extends StatefulWidget {
  @override
  _ImageCheckingState createState() => _ImageCheckingState();
}

class _ImageCheckingState extends State<ImageChecking> {
  @override
  void initState() {
    img;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imgSent = ModalRoute.of(context).settings.arguments;
    img = imgSent['img'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    img,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          SentSituation(
            send: () {},
            icon: Icons.done_all,
            iconColor: Colors.white,
            color: mainCTA,
            text: send,
            textColor: Colors.white,
          ),
          SizedBox(width: 5.0.w),
          SentSituation(
            send: () => Navigator.pop(context),
            icon: Icons.delete_outline,
            iconColor: Colors.black,
            text: abort,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
