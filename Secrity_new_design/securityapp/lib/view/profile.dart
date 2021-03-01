import 'dart:async';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/controller/gettingLogin.dart';
import 'package:securityapp/controller/imgConversion.dart';
import 'package:securityapp/controller/localDataController.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:sizer/sizer.dart';

// Conversion Image
ConvertImage convert = ConvertImage();
File imgSource;
// Local Storage Controller Class
LoadingLocalData LLDs = LoadingLocalData();
// Auth Users for updaing avatar of Staff
AuthUsers auth = AuthUsers();

String token = "";
String fullname = "";
String avatar = "";
String email = "";
String naturalCode = "";
String persCode = "";
String buildingsFarsiName = "";

Timer timer;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Will getting user local data from Flutter Secure Storage
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      LLDs.gettingStaffInfoInLocal().then((local) {
        setState(() {
          avatar = local["avatar"];
        });
      });
    });

    LLDs.gettingStaffInfoInLocal().then((local) {
      setState(() {
        token = local["token"];
        fullname = local["fullname"];
        avatar = local["avatar"];
        email = local["email"];
        naturalCode = local["naturalCode"];
        persCode = local["personalCode"];
        buildingsFarsiName = local["buildingNameFA"];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    imgSource = null;
    super.dispose();
  }

  Future gettingPhoto(ImageSource sourceType) async {
    final image = await ImagePicker.pickImage(
      source: sourceType,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 50,
    );
    // setState(() {
    //   imgSource = image;
    // });
    String _img64 = await convert.img2Base64(img: image);
    // print(_img64);
    bool result = await auth.updateStaffAvatar(avatar: _img64, token: token);
    if (result) {
      showStatusInCaseOfFlush(
        context: context,
        title: successSendTitle,
        msg: successSendDsc,
        icon: Icons.supervised_user_circle,
        iconColor: Colors.red,
      );
      // Getting Staff Info from Server for avatar
      Map staffInfo = await auth.gettingStaffInfo(token);
      var newImageAvatar = staffInfo["avatar"];
      // Saving Data
      final lStorage = FlutterSecureStorage();
      await lStorage.write(key: "avatar", value: newImageAvatar);
    } else {
      showStatusInCaseOfFlush(
        context: context,
        title: failureSendTitle,
        msg: failureSendDsc,
        icon: Icons.supervised_user_circle,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 40.0.h,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: CustomText(
                text: fullname,
                fw: FontWeight.bold,
                size: 10.0.sp,
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8), BlendMode.dstATop),
                    image: new NetworkImage(
                      avatar,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    showAdaptiveActionSheet(
                      context: context,
                      title: CustomText(
                        text: ": انتخاب تصویر با استفاده از",
                        fw: FontWeight.bold,
                        size: 14.0.sp,
                      ),
                      actions: <BottomSheetAction>[
                        BottomSheetAction(
                            title: CustomText(
                              text: "گالری",
                            ),
                            onPressed: () {
                              gettingPhoto(ImageSource.gallery);
                              Navigator.pop(context);
                            }),
                        BottomSheetAction(
                          title: CustomText(
                            text: "دوربین",
                          ),
                          onPressed: () {
                            gettingPhoto(ImageSource.camera);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                      cancelAction: CancelAction(
                        title: const CustomText(
                          text: 'لغو',
                          color: Colors.red,
                        ),
                      ),
                    );
                  }),
            ],
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
                            height: 2.0.h,
                          ),
                          TilsInfo(
                            textTitle: "حساب کاربری",
                            textSubtitle: fullname,
                          ),
                          TilsInfo(
                            textTitle: "آدرس پست الکترونیکی",
                            textSubtitle: email,
                          ),
                          TilsInfo(
                            textTitle: "کد پرسنلی",
                            textSubtitle: persCode,
                          ),
                          TilsInfo(
                            textTitle: "کد ملی",
                            textSubtitle: naturalCode,
                          ),
                        ],
                      ),
                    ),
                childCount: 1),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 10.0.h,
        child: MaterialButton(
          onPressed: () {
            // Will be logout
          },
          color: Colors.red,
          child: CustomText(
            text: "خروج از حساب",
            color: Colors.white,
            size: 14.0.sp,
          ),
        ),
      ),
    );
  }
}

class TilsInfo extends StatelessWidget {
  const TilsInfo({
    this.textTitle,
    this.textSubtitle,
  });

  final textTitle;
  final textSubtitle;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        title: CustomText(
          text: textTitle != null ? textTitle : "",
        ),
        subtitle: CustomText(text: textSubtitle != null ? textSubtitle : ""),
      ),
    );
  }
}
