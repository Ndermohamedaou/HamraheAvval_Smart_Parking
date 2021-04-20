import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:xlive_switch/xlive_switch.dart';
import 'package:sizer/sizer.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: initSettingsText,
        ),
        backgroundColor: mainCTA,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    XlivSwitch(
                      value: themeChange.darkTheme,
                      onChanged: (themeValue) =>
                          setState(() => themeChange.darkTheme = themeValue),
                    ),
                    CustomText(
                      text: themeText,
                      size: 13.0.sp,
                    )
                  ],
                ),
              ),
              Divider(
                height: 20,
                thickness: 2,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  color: themeChange.darkTheme ? darkBgColor : lightBgColor,
                  child: FlatButton(
                    onPressed: () => Navigator.pushNamed(context, setAppLock),
                    child: ListTile(
                      title: Text(
                        "تنظیم گذرواژه ورودی برای اپلیکیشن",
                        style: TextStyle(fontFamily: mainFont, fontSize: 15),
                      ),
                      leading: Icon(
                        Icons.lock_outline,
                        color: Colors.orangeAccent,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
