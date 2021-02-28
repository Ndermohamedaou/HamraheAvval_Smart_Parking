import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

File imgSource;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Will getting user local data from Flutter Secure Storage
  @override
  void initState() {
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
    setState(() {
      imgSource = image;
    });
    print(imgSource);
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
                text: "علیرضا سلطانی نشان",
                fw: FontWeight.bold,
                size: 10.0.sp,
              ),
              background: imgSource != null
                  ? Image.file(
                      imgSource,
                      fit: BoxFit.cover,
                    )
                  : Image.asset("assets/images/profileTest.png",
                      fit: BoxFit.cover),
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
                            // TODO
                            textSubtitle: "Alireza.Codes",
                          ),
                          TilsInfo(
                            textTitle: "آدرس پست الکترونیکی",
                            // TODO
                            textSubtitle: "asn80.asn@gmail.com",
                          ),
                          TilsInfo(
                            textTitle: "کد پرسنلی",
                            // TODO
                            textSubtitle: "9823123",
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
