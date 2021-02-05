import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/textField.dart';
import 'package:payausers/Screens/confirmInfo.dart';
import 'package:payausers/controller/reserveController.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String newEmail = "";
dynamic emptyTextFieldErrEmail = null;
bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(newEmail);

ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

class ModifyUserEmail extends StatefulWidget {
  @override
  _ModifyUserEmailState createState() => _ModifyUserEmailState();
}

class _ModifyUserEmailState extends State<ModifyUserEmail> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    void modifyUserEmail(newEmailSubmission) async {
      if (newEmailSubmission != "") {
        final uToken = await lds.read(key: "token");
        var result =
            await api.modifyUserEmail(token: uToken, email: newEmailSubmission);
        if (result == "200") {
          await lds.write(key: "email", value: newEmailSubmission);
          alert(
              context: context,
              tAlert: AlertType.success,
              title: "عملیات با موفقیت انجام شد",
              desc: "ایمیل شما با موفقیت ویرایش شد",
              themeChange: themeChange.darkTheme);
        } else {
          alert(
              context: context,
              tAlert: AlertType.error,
              title: "عملیات با شکست رو به رو شد",
              desc: "باری دیگر عمل ویرایش ایمیل خود را انجام دهید",
              themeChange: themeChange.darkTheme);
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
