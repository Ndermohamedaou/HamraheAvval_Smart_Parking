import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/titleStyle/titles.dart';
import 'classes/SavingLocalStorage.dart';
import 'package:toast/toast.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'classes/ApiAccess.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'controller/safe_control_settings.dart';

HexColor backPanelColor = HexColor('#1a2e48');
Map<String, Object> source;

class CameraInsertion extends StatefulWidget {
  @override
  _CameraInsertionState createState() => _CameraInsertionState();
}

class _CameraInsertionState extends State<CameraInsertion> {
  // Again Sending To submit entry time
  Future preparingImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        source['img'] = image;
      });
    } else {
      source['img'] = null;
    }
  }

  // Prepare img to send it on api
  Future sendingImage(rawImage) async {
    try {
      // print(rawImage.path);
      // Converting img file to form data
      // FormData formData = await convertingImg(rawImage);

      final bytesImg = rawImage.readAsBytesSync();

      String _img64 = base64Encode(bytesImg);

      // print(_img64);

      ApiAccess api = ApiAccess();
      // Getting User Token
      LocalizationDataStorage lds = LocalizationDataStorage();
      String uToken = await lds.gettingUserToken();

      Map res = await api.submittingCarPlate(
          uToken: uToken, plate: _img64, cameraState: "0");
      int status = res['status'];
      print("*****************");
      print(res);
      print("*****************");
      String msg = "";
      if (status == 200) {
        setState(() {
          msg = submissionMsg;
        });
      } else if (status == 350) {
        setState(() {
          msg = notEmptyMsg;
        });
      } else if (status == 100) {
        setState(() {
          msg = recentlyUsedMsg;
        });
      } else if (status == 150) {
        setState(() {
          msg = badImgEquality;
        });
      }

      if (res != null) {
        Navigator.pop(context);
        showSearchResult(context, res, msg);
      } else {
        Toast.show(failedMsg, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }

      // print(uToken);
      // Sending Req to API
      // Map senderStatus =
      //     await api.sendingCarImg(uToken: uToken, plate: formData);
      // print(senderStatus);
      // if (senderStatus != null) {
      //   Navigator.pop(context);
      //   showSearchResult(context, senderStatus);
      // } else {
      //   Toast.show(failedMsg, context,
      //       duration: Toast.LENGTH_LONG,
      //       gravity: Toast.BOTTOM,
      //       textColor: Colors.white);
      // }

    } catch (e) {
      Toast.show("تصویر نادرست است", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
      print("************************");
      print(e);
      print("************************");
    }
  }

  Future<FormData> convertingImg(imgFile) async {
    var formData = FormData();
    formData.files.add(MapEntry("plate",
        await MultipartFile.fromFile(imgFile.path, filename: "carPlate.png")));
    return formData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تایید تصویر",
          style: TextStyle(fontFamily: mainFontFamily),
        ),
        backgroundColor: appBarBackgroundColor,
        actions: [
          FlatButton(
            onPressed: () {
              preparingImage();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                CupertinoIcons.camera,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
            onPressed: () {
              sendingImage(source['img']);
            },
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
  @override
  Widget build(BuildContext context) {
    // To get img from right side
    source = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 500,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: source != null
                      ? Image.file(
                          source['img'],
                          alignment: Alignment.center,
                          fit: BoxFit.fitWidth,
                        )
                      : Text("لطفا تصویر خود را وارد کنید")),
            )
          ],
        ),
      ),
    );
  }
}
