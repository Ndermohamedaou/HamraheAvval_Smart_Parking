import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/reserveController.dart';
import 'package:payausers/controller/validator/textValidator.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String newEmail;
dynamic emptyTextFieldErrEmail;

ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

class ModifyUserEmail extends StatefulWidget {
  @override
  _ModifyUserEmailState createState() => _ModifyUserEmailState();
}

class _ModifyUserEmailState extends State<ModifyUserEmail> {
  @override
  void initState() {
    newEmail = "";
    emptyTextFieldErrEmail = null;
    super.initState();
  }

  @override
  void dispose() {
    newEmail = "";
    emptyTextFieldErrEmail = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    void modifyUserEmail(newEmailSubmission) async {
      if (newEmailSubmission != "") {
        bool gettingEmailIsEmail = emailValidator(newEmailSubmission);

        if (gettingEmailIsEmail) {
          final uToken = await lds.read(key: "token");
          try {
            var result = await api.modifyUserEmail(
                token: uToken, email: newEmailSubmission);
            if (result == "200") {
              await lds.write(key: "email", value: newEmailSubmission);
              alert(
                  context: context,
                  tAlert: AlertType.success,
                  title: successChangedEmailTitle,
                  desc: successChangedEmailDesc,
                  themeChange: themeChange.darkTheme);
            } else {
              alert(
                  context: context,
                  tAlert: AlertType.error,
                  title: failedChangedEmailTitle,
                  desc: failedChangedEmailDesc,
                  themeChange: themeChange.darkTheme);
            }
          } catch (e) {
            alert(
                context: context,
                tAlert: AlertType.error,
                title: failedChangedServerEmailTitle,
                desc: failedChangedServerEmailDesc,
                themeChange: themeChange.darkTheme);
          }
        } else {
          showStatusInCaseOfFlush(
              context: context,
              title: emailSubmissionStructureError,
              msg: emailSubmissionStructureErrorDesc,
              icon: Icons.email,
              iconColor: Colors.deepOrange);
        }
      } else {
        setState(() {
          emptyTextFieldErrEmail = emptyTextFieldMsg;
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios_rounded)),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "ویرایش آدرس ایمیل",
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: subTitleSize),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextFields(
                lblText: "ایمیل جدید شما",
                textFieldIcon: Icons.email,
                textInputType: false,
                readOnly: false,
                errText:
                    emptyTextFieldErrEmail == null ? null : emptyTextFieldMsg,
                onChangeText: (onChangeEmail) {
                  setState(() {
                    emptyTextFieldErrEmail = null;
                    newEmail = onChangeEmail;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.blue,
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              modifyUserEmail(newEmail);
            },
            child: Text(
              submitAvatarChanged,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: mainFaFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}