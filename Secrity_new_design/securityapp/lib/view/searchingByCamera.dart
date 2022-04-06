import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/imgConversion.dart';
import 'package:securityapp/controller/searchingController.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/provider/abuse_warning_model.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/capturingButton.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:sizer/sizer.dart';

File imgSource;
dynamic themeChange;
ConvertImage convertImage = ConvertImage();
SearchingCar searchMethod = SearchingCar();

class SearchingByCamera extends StatefulWidget {
  @override
  _SearchingByCameraState createState() => _SearchingByCameraState();
}

class _SearchingByCameraState extends State<SearchingByCamera> {
  @override
  Widget build(BuildContext context) {
    AbuseWarningModel abuseWarningModel =
        Provider.of<AbuseWarningModel>(context);
    themeChange = Provider.of<DarkThemeProvider>(context);

    Future gettingPhoto(ImageSource sourceType) async {
      final lStorage = FlutterSecureStorage();
      String buildingName = await lStorage.read(key: "buildingName");
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: sourceType);
      File imgFile = File(image.path);
      setState(() => imgSource = imgFile);

      if (imgSource != null) {
        String capturedImage = await convertImage.img2Base64(img: imgFile);
        // print(capturedImage);
        // Sending base 64 to api
        //  // init Flutter Secure Storage
        // First getting token form Flutter local storage
        final lStorage = FlutterSecureStorage();
        final token = await lStorage.read(key: "uToken");
        // Getting only result from searched
        // image (Image processing on the plate number)
        final admitImageResult = await searchMethod.searchingByCapturedImage(
          token: token,
          capturedImage: capturedImage,
          building: buildingName,
        );

        // print("Result is ===> $admitImageResult");
        if (admitImageResult.isNotEmpty) {
          Navigator.pushNamed(context, searchResults, arguments: {
            "status": admitImageResult["status"],
            "meta": admitImageResult["meta"],
          });

          // Setting the personal code for abuse list api call.
          abuseWarningModel.setAbuseReportPersonalCode =
              admitImageResult["status"]["personal_code"];
          abuseWarningModel.getAbuseList;
        } else
          showStatusInCaseOfFlush(
            context: context,
            title: notFoundTitle,
            msg: notFoundDsc,
            icon: Icons.close,
            iconColor: Colors.red,
          );
      } else {
        showStatusInCaseOfFlush(
          context: context,
          title: "جست و جوی مورد خالی غیر ممکن است",
          msg: "حداقل یک تصویر را برای جست و جو انتخاب کنید",
          icon: Icons.close,
          iconColor: Colors.red,
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName(mainoRoute));
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: mainCTA,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: CustomText(
                  text: searchingByPhotoCapturing,
                  fw: FontWeight.bold,
                  size: 12.0.sp,
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
                                text: searchingByCameraTextTooltip,
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
                                    gettingPhoto(ImageSource.camera);
                                  },
                                  icon: Icons.photo_camera_outlined,
                                  text: cameraBtnText,
                                ),
                                SizedBox(width: 5.0.w),
                                CapturingOption(
                                  capture: () {
                                    gettingPhoto(ImageSource.gallery);
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
                tooltip: searchText,
                icon: Icon(
                  Icons.search_sharp,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, searchByPlateRoute)),
            IconButton(
                tooltip: slotText,
                icon: Icon(
                  Icons.playlist_add_check_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, searchBySlotRoute)),
            IconButton(
                tooltip: personalCodeSearchText,
                icon: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, searchByPersCodeRoute)),
          ],
        ),
      ),
    );
  }
}
