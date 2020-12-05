import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'constFile/ConstFile.dart';
import 'titleStyle/titles.dart';
import 'extractsWidget/optStyle.dart';
import 'constFile/texts.dart';

class AdddingDataMethods extends StatefulWidget {
  @override
  _AdddingDataMethodsState createState() => _AdddingDataMethodsState();
}

class _AdddingDataMethodsState extends State<AdddingDataMethods> {
  @override
  Widget build(BuildContext context) {
    File _image;

    Future preparingImage() async {
      final image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        print(_image.path);
        if (_image != null) {
          Navigator.pushNamed(context, '/CameraInsertion',
              arguments: {"img": _image});
        } else
          return null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleConfig(
          titleText: "اطلاعات را وارد کنید",
          textStyles: TextStyle(
              fontSize: fontTitleSize,
              fontFamily: titleFontFamily,
              color: Colors.white),
          titleAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Column(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                print('Static Entry');
                Navigator.pushNamed(context, '/StaticInsertion');
              },
              child: OptionsViewer(
                text: opt1,
                desc: opt1Desc,
                avatarIcon: opt1Icon,
                avatarBgColor: mainIconColor,
                iconColor: bothIconNativeColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                // print('Camera Entry');
                // Navigator.pushNamed(context, '/CameraInsertion');
                preparingImage();
              },
              child: OptionsViewer(
                text: opt2,
                desc: opt2Desc,
                avatarIcon: opt2Icon,
                avatarBgColor: mainIconColor,
                iconColor: bothIconNativeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
