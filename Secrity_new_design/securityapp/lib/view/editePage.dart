import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/controller/edit_Contaroller.dart';
import 'package:securityapp/controller/localDataController.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/validator/regex.dart';
import 'package:securityapp/widgets/bottomBtn.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:securityapp/widgets/textField.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/widgets/CustomText.dart';

// Local Data
LoadingLocalData LLDS = LoadingLocalData();
EditStaffInfo editStaff = EditStaffInfo();

String editedEmail = "";
String newPass = "";
String confrimNewPass = "";
var protectedPassword;
IconData showMePass = Icons.remove_red_eye;

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    editedEmail = "";
    newPass = "";
    confrimNewPass = "";
    protectedPassword = true;
    showMePass = Icons.vpn_key;

    super.initState();
  }

  @override
  void dispose() {
    editedEmail = "";
    newPass = "";
    confrimNewPass = "";
    protectedPassword = true;
    showMePass = Icons.vpn_key;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    void submitEditedEmail({token, String email}) async {
      print(email);
      final lStorage = FlutterSecureStorage();
      bool valEmail = emailValidator(email);
      if (valEmail) {
        if (email != "") {
          bool result = await editStaff.changeEmail(token: token, email: email);
          if (result) {
            Navigator.pop(context);
            showStatusInCaseOfFlush(
              context: context,
              title: successSendTitle,
              msg: editedEmailSubmited,
              icon: Icons.done_all,
              iconColor: Colors.green,
            );
            await lStorage.write(key: "email", value: email);
          } else {
            showStatusInCaseOfFlush(
              context: context,
              title: failureSendTitle,
              msg: failureEmailSubmit,
              icon: Icons.close,
              iconColor: Colors.red,
            );
          }
        } else {
          showStatusInCaseOfFlush(
            context: context,
            title: emptyMsgTitle,
            msg: emptyMsgDsc,
            icon: Icons.warning,
            iconColor: Colors.orange,
          );
        }
      } else {
        showStatusInCaseOfFlush(
          context: context,
          title: emailRegexFailedTitle,
          msg: emailRegexFailedDsc,
          icon: Icons.warning,
          iconColor: Colors.orange,
        );
      }
    }

    void openEmailEdit() {
      // Getting token and send it to api
      setState(() => editedEmail = "");
      String token = "";
      LLDS
          .gettingStaffInfoInLocal()
          .then((local) => setState(() => token = local["token"]));
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 20),
                    child: CustomText(
                      text: "ویرایش آدرس پست الکترونیکی",
                      size: 14.0.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0.h),
              TextFields(
                keyType: TextInputType.emailAddress,
                lblText: emailText,
                textFieldIcon: Icons.playlist_add_check_rounded,
                textInputType: false,
                readOnly: false,
                onChangeText: (onChangeEmail) =>
                    setState(() => editedEmail = onChangeEmail),
              ),
              SizedBox(height: 30.0.h),
              BottomButton(
                color: mainCTA,
                text: "ثبت پست الکترونیکی جدید",
                onTapped: () =>
                    submitEditedEmail(token: token, email: editedEmail),
              ),
            ],
          ),
        ),
      );
    }

    void submitEditedPass({token, String pass, String rePass}) async {
      // print("$pass -- $rePass");
      if (pass == rePass) {
        if (pass.length >= 6 && rePass.length >= 6) {
          bool valPass = passwordRegex(pass);
          bool valRePass = passwordRegex(rePass);
          if (valPass && valRePass) {
            // Api calling
            bool result =
                await editStaff.changePassword(token: token, pass: pass);

            if (result) {
              Navigator.pop(context);
              showStatusInCaseOfFlush(
                context: context,
                title: passChangedTitle,
                msg: passChangedDsc,
                icon: Icons.done_all,
                iconColor: Colors.green,
              );
            } else {
              showStatusInCaseOfFlush(
                context: context,
                title: passNotChangedTitle,
                msg: passNotChangedDsc,
                icon: Icons.close,
                iconColor: Colors.red,
              );
            }
          } else {
            // Invalid password
            showStatusInCaseOfFlush(
              context: context,
              title: passInvalidTitle,
              msg: passInvalidDsc,
              icon: Icons.warning_amber_outlined,
              iconColor: Colors.orange,
            );
          }
        } else {
          // Length not enough
          showStatusInCaseOfFlush(
            context: context,
            title: passNoEnoughLenTitle,
            msg: passNoEnoughLenDsc,
            icon: Icons.legend_toggle_sharp,
            iconColor: Colors.red,
          );
        }
      } else {
        // Not Match
        showStatusInCaseOfFlush(
            context: context,
            title: passNotMatchTitle,
            msg: passNotMatchDsc,
            icon: Icons.close,
            iconColor: Colors.red);
      }
    }

    void openPasswordChanger() {
      setState(() {
        newPass = "";
        confrimNewPass = "";
        // protectedPassword = true;
      });
      IconData showMePass = Icons.remove_red_eye;

      String token = "";
      LLDS
          .gettingStaffInfoInLocal()
          .then((local) => setState(() => token = local["token"]));
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 20),
                    child: CustomText(
                      text: "ویرایش گذرواژه ورودی",
                      size: 14.0.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0.h),
              TextFields(
                initValue: newPass,
                lblText: "گذرواژه",
                keyType: TextInputType.text,
                maxLen: 20,
                readOnly: false,
                textInputType: protectedPassword,
                textFieldIcon:
                    newPass == "" ? Icons.vpn_key_outlined : showMePass,
                iconPressed: () {
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
                onChangeText: (newPassChange) =>
                    setState(() => newPass = newPassChange),
              ),
              SizedBox(height: 10),
              TextFields(
                initValue: confrimNewPass,
                lblText: "تکرار گذرواژه",
                keyType: TextInputType.text,
                maxLen: 20,
                readOnly: false,
                textInputType: protectedPassword,
                textFieldIcon:
                    confrimNewPass == "" ? Icons.vpn_key_outlined : showMePass,
                iconPressed: () {
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
                onChangeText: (onChangeRePass) =>
                    setState(() => confrimNewPass = onChangeRePass),
              ),
              SizedBox(height: 30.0.h),
              BottomButton(
                color: mainCTA,
                text: "ثبت گذرواژه جدید",
                onTapped: () => submitEditedPass(
                  token: token,
                  pass: newPass,
                  rePass: confrimNewPass,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
        centerTitle: true,
        title: CustomText(
          text: "ویرایش اطلاعات",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 5.0.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 15.0.h,
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? darkOptionBg : lightOptionBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 2.0.w),
                    FlatButton(
                      onPressed: () => openPasswordChanger(),
                      child: OptionTile(
                        title: "ویرایش گذرواژه",
                        subtitle:
                            "ویرایش گذرواژه خود برای تامین امنیت بیشتر در حریم خصوصی خود",
                        icon: Icons.vpn_key,
                        iconColor: Colors.white,
                        iconBg: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    this.icon,
    this.iconColor,
    this.iconBg,
    this.title,
    this.subtitle,
  });

  final icon;
  final iconColor;
  final iconBg;
  final title;
  final subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          leading: CircleAvatar(
            radius: 5.0.w,
            child: Icon(
              icon,
              color: iconColor,
            ),
            backgroundColor: iconBg,
          ),
          title: CustomText(
            text: title,
            fw: FontWeight.bold,
          ),
          subtitle: CustomText(
            text: subtitle != null ? subtitle : "",
          ),
        ),
      ),
    );
  }
}
