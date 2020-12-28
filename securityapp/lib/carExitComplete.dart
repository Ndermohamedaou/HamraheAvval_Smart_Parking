import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'classes/ApiAccess.dart';
import 'classes/SavingLocalStorage.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'controller/safe_control_settings.dart';
import 'titleStyle/titles.dart';

Map<String, Object> source;

class StaticInsertion extends StatefulWidget {
  @override
  _StaticInsertionState createState() => _StaticInsertionState();
}

class _StaticInsertionState extends State<StaticInsertion> {
  // Prepare img to send it on api
  Future exitSubmission(rawImage) async {
    try {
      final bytesImg = rawImage.readAsBytesSync();

      String _img64 = base64Encode(bytesImg);

      print(_img64);

      ApiAccess api = ApiAccess();
      // Getting User Token
      LocalizationDataStorage lds = LocalizationDataStorage();
      String uToken = await lds.gettingUserToken();

      Map res = await api.submittingCarPlate(
          uToken: uToken, plate: _img64, cameraState: "1");
      int status = res['status'];
      // print("===================");
      // print(res);
      // print("===================");
      String msg = "";
      if (status == 1200) {
        setState(() {
          msg = submissionMsg;
        });
      } else if (status == 150) {
        setState(() {
          msg = badImgEquality;
        });
      } else if (status == 1100) {
        setState(() {
          msg = "اطلاعاتی در مورد این پلاک موجود نیست";
        });
      } else if (status == 550) {
        setState(() {
          msg = failedResponse;
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
    } catch (e) {
      Toast.show("تصویر نادرست است", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleConfig(
          titleText: exitSubmissionText,
          textStyles: TextStyle(
            fontSize: fontTitleSize,
            fontFamily: titleFontFamily,
          ),
          titleAlign: TextAlign.center,
        ),
        backgroundColor: appBarBackgroundColor,
      ),
      body: StaticInsertionBody(),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue[900],
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              exitSubmission(source['img']);
            },
            child: Text(
              sending,
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

class StaticInsertionBody extends StatefulWidget {
  @override
  _StaticInsertionBodyState createState() => _StaticInsertionBodyState();
}

class _StaticInsertionBodyState extends State<StaticInsertionBody> {
  @override
  Widget build(BuildContext context) {
    source = ModalRoute.of(context).settings.arguments;
    // print(source['img']);
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
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
