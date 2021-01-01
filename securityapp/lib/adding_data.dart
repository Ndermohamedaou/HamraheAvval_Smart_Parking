import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';
import 'titleStyle/titles.dart';
import 'extractsWidget/optStyle.dart';
import 'constFile/texts.dart';
import 'package:lottie/lottie.dart';

class AdddingDataMethods extends StatefulWidget {
  @override
  _AdddingDataMethodsState createState() => _AdddingDataMethodsState();
}

class _AdddingDataMethodsState extends State<AdddingDataMethods> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    File _image;

    Future preparingImage(navigatedPage, method) async {
      final image = await ImagePicker.pickImage(source: method);
      setState(() {
        _image = image;
        print(_image.path);
        if (_image != null) {
          Navigator.pushNamed(context, '/$navigatedPage',
              arguments: {"img": _image});
        } else
          return null;
      });
    }

    selectedMethod(navigation) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                backgroundColor: themeChange.darkTheme
                    ? scaffoldBackgroundColor
                    : Colors.white,
                title: AppBarTitleConfig(
                  titleText: "نوع ورود تصویر",
                  textStyles: TextStyle(
                      fontFamily: mainFontFamily, fontWeight: FontWeight.bold),
                ),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lottie/carCheckingLight.json"),
                      FlatButton(
                        onPressed: () {
                          preparingImage(navigation, ImageSource.camera);
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              cameraText,
                              style: TextStyle(
                                  color: themeChange.darkTheme
                                      ? Colors.white
                                      : scaffoldBackgroundColor,
                                  fontFamily: mainFontFamily,
                                  fontSize: fontDialogSize),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.camera,
                                size: iconDialogSize, color: Colors.redAccent)
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          preparingImage(navigation, ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              galleryText,
                              style: TextStyle(
                                  color: themeChange.darkTheme
                                      ? Colors.white
                                      : scaffoldBackgroundColor,
                                  fontFamily: mainFontFamily,
                                  fontSize: fontDialogSize),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.image,
                              size: iconDialogSize,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
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
        child: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(
                  "assets/lottie/contribute-to-empty-slot.json"),
              GestureDetector(
                onTap: () {
                  // preparingImage("CameraInsertion");
                  selectedMethod("CameraInsertion");
                },
                child: OptionsViewer(
                  text: opt2,
                  desc: opt2Desc,
                  avatarIcon: opt2Icon,
                  avatarBgColor: mainIconColor,
                  iconColor: bothIconNativeColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // preparingImage("StaticInsertion");
                  selectedMethod("StaticInsertion");
                },
                child: OptionsViewer(
                  text: opt1,
                  desc: opt1Desc,
                  avatarIcon: opt1Icon,
                  avatarBgColor: mainIconColor,
                  iconColor: bothIconNativeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
