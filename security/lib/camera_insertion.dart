import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'classes/SavingLocalStorage.dart';
import 'package:toast/toast.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'classes/ApiAccess.dart';

HexColor backPanelColor = HexColor('#1a2e48');
Map<String, Object> source;

class CameraInsertion extends StatefulWidget {
  @override
  _CameraInsertionState createState() => _CameraInsertionState();
}

class _CameraInsertionState extends State<CameraInsertion> {
  Future preparingImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      source['img'] = image;
    });
  }

  // Prepare img to send it on api
  Future sendingImage(rawImage) async {
    try {
      // Converting img file to form data
      FormData formData = await convertingImg(rawImage);
      ApiAccess api = ApiAccess();
      // Getting User Token
      LocalizationDataStorage lds = LocalizationDataStorage();
      String uToken = await lds.gettingUserToken();
      // print(uToken);
      // Sending Req to API
      bool senderStatus =
          await api.sendingCarImg(uToken: uToken, plate: formData);
      if (senderStatus) {
        Toast.show(sendingSuccessMsg, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
        Navigator.pop(context);
      } else {
        Toast.show(failedMsg, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    } catch (e) {
      Toast.show(serverNotResponse, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
      print(e);
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
                child: Image.file(
                  source['img'],
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
