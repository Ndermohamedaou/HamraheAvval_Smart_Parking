import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/gettingLogin.dart';
import 'package:securityapp/controller/imgConversion.dart';
import 'package:securityapp/validator/regex.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/bottomBtn.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:sizer/sizer.dart';
import 'confirmationPages/mainProfile.dart';
import 'confirmationPages/passwords.dart';

var token = "";
int pageIndex = 0;
var _pageController;

// Image conversion class
ConvertImage imgConvertion = ConvertImage();
AuthUsers auth = AuthUsers();

// Level 1
String email = "";
File imageSource;

// Level 2
String password = "";
String rePassword = "";
var protectedPassword;
IconData showMePass = Icons.remove_red_eye;

class Confirmation extends StatefulWidget {
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  @override
  void initState() {
    pageIndex = 0;
    _pageController = PageController();
    showMePass = Icons.remove_red_eye;
    protectedPassword = true;

    super.initState();
  }

  @override
  void dispose() {
    pageIndex = 0;
    _pageController.dispose();
    email = "";
    password = "";
    rePassword = "";
    showMePass = Icons.vpn_key;
    protectedPassword = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    token = ModalRoute.of(context).settings.arguments;

    Future gettingPhoto(ImageSource sourceType) async {
      final image = await ImagePicker.pickImage(
        source: sourceType,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 50,
      );
      setState(() {
        imageSource = image;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => pageIndex = index),
          children: [
            MainProfile(
              avatarView: imageSource,
              avatarPressed: () {
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
              },
              userEmail: email,
              onChangeEmail: (changedEmail) {
                setState(() => email = changedEmail);
              },
            ),
            Password(
              pass: password,
              onChangePass: (onPass) => setState(() => password = onPass),
              rePass: rePassword,
              onChangeRePass: (onRePass) =>
                  setState(() => rePassword = onRePass),
              passIconPressed: () {
                setState(() {
                  protectedPassword
                      ? protectedPassword = false
                      : protectedPassword = true;
                  // Changing eye icon pressing
                  showMePass == Icons.remove_red_eye
                      ? showMePass = Icons.remove_red_eye_outlined
                      : showMePass = Icons.remove_red_eye;
                });
              },
              protectedPassword: protectedPassword,
              showMePass: showMePass,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        color: mainCTA,
        onTapped: () {
          pageIndex == 1
              ? updateStaffInfo(
                  avatar: imageSource,
                  email: email,
                  uToken: token,
                  pass: password,
                  rePass: rePassword,
                )
              : nextPageIndex();
        },
        text: pageIndex == 1 ? submitUpdateStaffInfo : next,
      ),
    );
  }

  void updateStaffInfo({avatar, email, pass, rePass, uToken}) async {
    if (email != "" && pass != "" && rePass != "") {
      bool valEmail = emailValidator(email);
      if (valEmail) {
        if (pass == rePass && pass.length > 6 && rePass.length > 6) {
          bool valPass = passwordRegex(pass);
          bool valRePass = passwordRegex(rePass);
          if (valPass && valRePass) {
            // Finlly go to update api
            String _img64 = await imgConvertion.img2Base64(img: avatar);
            bool result = await auth.updateStaffInfo(
              avatar: _img64,
              email: email,
              pass: pass,
              token: token,
            );
            if (result)
              Navigator.pushNamed(context, buildingsRoute, arguments: token);
            else {
              showStatusInCaseOfFlush(
                context: context,
                title: updaingProblemTitle,
                msg: updaingProblemDsc,
                icon: Icons.edit_attributes_outlined,
                iconColor: Colors.red,
              );
            }
          } else {
            showStatusInCaseOfFlush(
              context: context,
              title: passValTitle,
              msg: passValDsc,
              icon: Icons.edit_attributes_outlined,
              iconColor: Colors.red,
            );
          }
        } else {
          showStatusInCaseOfFlush(
            context: context,
            title: notMathPassTitle,
            msg: notMathPassDsc,
            icon: Icons.edit_attributes_outlined,
            iconColor: Colors.red,
          );
        }
      } else {
        showStatusInCaseOfFlush(
          context: context,
          title: emailValTitle,
          msg: emailValDsc,
          icon: Icons.edit_attributes_outlined,
          iconColor: Colors.red,
        );
      }
    } else {
      showStatusInCaseOfFlush(
        context: context,
        title: emptyBoxTitle,
        msg: emptyBoxDsc,
        icon: Icons.edit_attributes_outlined,
        iconColor: Colors.red,
      );
    }
  }

  void nextPageIndex() {
    setState(() => pageIndex += 1);
    _pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 600), curve: Curves.decelerate);
  }
}
