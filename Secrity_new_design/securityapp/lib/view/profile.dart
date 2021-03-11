import 'dart:async';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/gettingLogin.dart';
import 'package:securityapp/controller/imgConversion.dart';
import 'package:securityapp/controller/localDataController.dart';
import 'package:securityapp/model/sqfliteLocalCheck.dart';
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

// Local Sql
SavedSecurity seveSecurity = SavedSecurity();

String token = "";
String fullname = "";
String avatar = "";
String email = "";
String naturalCode = "";
String persCode = "";
String buildingsFarsiName = "";
double mainSliverBgSize = 40.0.h;

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
      loadStaffInfo();
    });
    loadStaffInfo();
    super.initState();
  }

  @override
  void dispose() {
    imgSource = null;
    mainSliverBgSize = 40.0.h;
    timer.cancel();
    super.dispose();
  }

  void loadStaffInfo() {
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
  }

  Future gettingPhoto(ImageSource sourceType) async {
    final image = await ImagePicker.pickImage(
      source: sourceType,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 50,
    );

    if (image != null) {
      String _img64 = await convert.img2Base64(img: image);
      // print(_img64);
      bool result = await auth.updateStaffAvatar(avatar: _img64, token: token);
      if (result) {
        showStatusInCaseOfFlush(
          context: context,
          title: successSendTitle,
          msg: successSendDsc,
          icon: Icons.done_all,
          iconColor: Colors.green,
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
          icon: Icons.close,
          iconColor: Colors.red,
        );
      }
    }
  }

  void logout() async {
    final lStorage = FlutterSecureStorage();
    await lStorage.deleteAll();
    await seveSecurity.delAllSavedSecurity();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: mainSliverBgSize,
            floating: false,
            pinned: true,
            backgroundColor: mainCTA,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              title: CustomText(
                text: fullname,
                fw: FontWeight.bold,
                size: 10.0.sp,
              ),
              background: GestureDetector(
                onTap: () => setState(() => mainSliverBgSize = 60.0.h),
                child: Container(
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
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, editPage),
              ),
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
                            textTitle: "ساختمان",
                            textSubtitle: buildingsFarsiName,
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
          onPressed: () => showAdaptiveActionSheet(
            context: context,
            title: CustomText(
              text: "آیا می خواهید حساب خود خارج شوید؟",
              fw: FontWeight.bold,
              size: 14.0.sp,
            ),
            actions: <BottomSheetAction>[
              BottomSheetAction(
                  title: CustomText(
                    text: "خروج",
                    color: Colors.red,
                    fw: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                  onPressed: () => logout()),
            ],
            cancelAction: CancelAction(
              title: const CustomText(
                text: 'لغو',
                color: Colors.blue,
              ),
            ),
          ),
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
