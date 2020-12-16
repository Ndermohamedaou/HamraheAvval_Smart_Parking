import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'classes/SharedClass.dart';
import 'extractsWidget/optStyle.dart';
import 'extractsWidget/car_details_widget.dart';

Map<String, Object> data = {};

class CarDetails extends StatefulWidget {
  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Plates Data
    data = ModalRoute.of(context).settings.arguments;
    // print(base64Decode(data['car_img']));
    // car_img = base64Decode(data['car_img']);
    // plate_img = base64Decode(data['Plate_img']);

    Widget properBASE64ImgConverting(String imgMemo) {
      print(imgMemo.length);
      if (imgMemo.length % 4 == 2) {
        imgMemo += "==";
      } else if (imgMemo.length % 4 == 3) {
        imgMemo += "=";
      }
      final convertedImage = Base64Decoder().convert(imgMemo);
      Widget image = Image.memory(convertedImage);
      return image;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جزئیات وسیله نقلیه',
          style: TextStyle(fontFamily: mainFontFamily),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PageViewContainer(
                imgPath: [
                  imgShower(path: properBASE64ImgConverting(data['car_img'])),
                  // imgShower(
                  //   path: Image.memory(
                  //     plate_img,
                  //     alignment: Alignment.center,
                  //     fit: BoxFit.fitWidth,
                  //   ),
                  // ),
                ],
              ),
              // GraphicalPlate(
              //   // themeChange: themeChange,
              //   plate0: data['plate0'],
              //   plate1: data['plate1'],
              //   plate2: data['plate2'],
              //   plate3: data['plate3'],
              // ),
              OptionsViewer(
                text: "شماره جایگاه",
                desc: "جایگاه ${data['slot']}",
                avatarIcon: CupertinoIcons.square_stack_3d_up,
                avatarBgColor: HexColor("#460EBB"),
                iconColor: Colors.white,
              ),
              OptionsViewer(
                text: "وضعیت جایگاه",
                desc: data['status'] == 1 ? "پر" : "خالی",
                avatarIcon: CupertinoIcons.app_fill,
                avatarBgColor: HexColor('#9EA7C2'),
                iconColor: bothIconNativeColor,
              ),
              OptionsViewer(
                text: "زمان ورود",
                desc: "${data['entry_datetime']}",
                avatarIcon: CupertinoIcons.time,
                avatarBgColor: HexColor('#4E4F84'),
                iconColor: Colors.white,
              ),
              OptionsViewer(
                text: "زمان خروج",
                desc: "${data['exit_datetime']}",
                avatarIcon: CupertinoIcons.time_solid,
                avatarBgColor: HexColor('#BEB3D1'),
                iconColor: bothIconNativeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
