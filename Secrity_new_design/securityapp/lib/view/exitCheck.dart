import 'dart:io';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/alert.dart';
import 'package:securityapp/widgets/capturingButton.dart';
import 'package:sizer/sizer.dart';

class ExitCheck extends StatefulWidget {
  @override
  _ExitCheckState createState() => _ExitCheckState();
}

class _ExitCheckState extends State<ExitCheck> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    Future gettingPhoto(ImageSource sourceType) async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(
        source: sourceType,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 50,
      );

      File imgFile = File(image.path);

      if (imgFile != null)
        Navigator.pushNamed(context, imgChecker,
            arguments: {"img": imgFile, "cameraStatus": "1"});
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(context, ModalRoute.withName(mainoRoute));
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 30.0.h,
              floating: false,
              pinned: true,
              backgroundColor: mainCTA,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: CustomText(
                  text: exitText,
                  fw: FontWeight.bold,
                  size: 10.0.sp,
                ),
                background: Image(
                  image: AssetImage("assets/images/checking.png"),
                  fit: BoxFit.cover,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName(mainoRoute));
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 8.0.h,
                            ),
                            Image.asset(
                              "assets/images/plateCapture.png",
                              width: 40.0.w,
                              height: 40.0.w,
                            ),
                            SizedBox(
                              height: 2.0.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              width: 85.0.w,
                              child: CustomText(
                                text: submissionTipText,
                                size: 11.0.sp,
                                align: TextAlign.center,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CapturingOption(
                                  capture: () {
                                    alertCheckTip(
                                        context: context,
                                        onPressed: () {
                                          gettingPhoto(ImageSource.camera);
                                          Navigator.pop(context);
                                        });
                                  },
                                  icon: Icons.photo_camera_outlined,
                                  text: cameraBtnText,
                                ),
                                SizedBox(width: 5.0.w),
                                CapturingOption(
                                  capture: () {
                                    alertCheckTip(
                                        context: context,
                                        onPressed: () {
                                          gettingPhoto(ImageSource.gallery);
                                          Navigator.pop(context);
                                        });
                                  },
                                  icon: Icons.photo_album_outlined,
                                  text: galleryBtnText,
                                )
                              ],
                            ),
                            SizedBox(height: 20.0.h),
                          ],
                        ),
                      ),
                  childCount: 1),
            )
          ],
        ),
        floatingActionButton: FabCircularMenu(
          fabColor: floatingAction,
          ringColor: floatingAction,
          ringDiameter: 400.0,
          children: <Widget>[
            IconButton(
                tooltip: enterText,
                icon: Icon(
                  Icons.login,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  final currentRoutePath = ModalRoute.of(context).settings.name;
                  if (currentRoutePath != "entryCheck") {
                    Navigator.pushNamed(context, entryCheck);
                  } else
                    null;
                }),
            IconButton(
                tooltip: exitText,
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  final currentRoutePath = ModalRoute.of(context).settings.name;
                  if (currentRoutePath != "exitCheck") {
                    Navigator.pushNamed(context, exitCheck);
                  } else
                    null;
                }),
          ],
        ),
      ),
    );
  }
}
