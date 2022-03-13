import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/imgConversion.dart';
import 'package:securityapp/controller/localDataController.dart';
import 'package:securityapp/controller/sendImgCheckerProcess.dart';
import 'package:securityapp/model/sqfliteLocalCheck.dart';
import 'package:securityapp/widgets/alert.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:securityapp/widgets/sentSituation.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initStrings.dart';

Map<dynamic, dynamic> imgSent;
File img;
String token = "";
// Image conversion class
ConvertImage imgConvertion = ConvertImage();
SavedSecurity saveSecurity = SavedSecurity();
LoadingLocalData LLDs = LoadingLocalData();
ImgProcessing imgProcessing = ImgProcessing();

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
    token = "";
    imgSent = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imgSent = ModalRoute.of(context).settings.arguments;
    img = imgSent['img'];

    // print(imgSent["cameraStatus"]);

    void sendChecker({img, status}) async {
      // print(img);
      // print(status);
      final lStorage = FlutterSecureStorage();
      String token = await lStorage.read(key: "uToken");
      String _img64 = await imgConvertion.img2Base64(img: img);

      try {
        final result = await imgProcessing.sendingImage(
            token: token, img: _img64, state: status);

        Navigator.pop(context);
        // TODO: Fix this for future, we need class of Alarm for specific type.
        if (result["status"] == "success")
          showStatusInCaseOfFlush(
            context: context,
            icon: Icons.done,
            iconColor: Colors.white,
            backgroundColor: fullSlotColors,
            title: result["message"]["title"],
            msg: result["message"]["desc"],
          );

        if (result["status"] == "warning")
          showStatusInCaseOfFlush(
            context: context,
            icon: Icons.done,
            iconColor: Colors.white,
            backgroundColor: mainSectionCTA,
            title: result["message"]["title"],
            msg: result["message"]["desc"],
          );

        if (result["status"] == "failed")
          showStatusInCaseOfFlush(
            context: context,
            icon: Icons.done,
            iconColor: Colors.white,
            title: result["message"]["title"],
            msg: result["message"]["desc"],
          );
      } catch (e) {
        print("Error in send data to server so i save it => $e");
        bool saveResult = await saveSecurity.addSavedSecurity(
            img: _img64, trafficType: status);
        if (saveResult) alertSayStatus(context: context);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    img,
                    width: 100.0.w,
                    height: 70.0.h,
                    fit: BoxFit.fitWidth,
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
            send: () => sendChecker(
                img: imgSent["img"], status: imgSent["cameraStatus"]),
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
            color: Colors.white,
            iconColor: Colors.black,
            text: abort,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
