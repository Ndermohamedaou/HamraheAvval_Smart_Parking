import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';

String appLockPassword = null;

class SetAppLockOTPView extends StatefulWidget {
  @override
  _SetAppLockOTPViewState createState() => _SetAppLockOTPViewState();
}

class _SetAppLockOTPViewState extends State<SetAppLockOTPView> {
  @override
  void initState() {
    gettingAppLockPassString()
        .then((value) => setState(() => appLockPassword = value));
    super.initState();
  }

  Future<String> gettingAppLockPassString() async {
    final lStorage = FlutterSecureStorage();
    return await lStorage.read(key: "local_lock");
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    void delAppLock() async {
      final lStorage = FlutterSecureStorage();
      await lStorage.delete(key: "local_lock");
    }

    // print("This is lock ? $appLockPassword");
    // print(themeChange.appLock);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
        title: Text(
          "تنظیم بایومتریک",
          style: TextStyle(
            fontFamily: mainFont,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: themeChange.darkTheme ? darkBgColor : lightBgColor,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: ListTileSwitch(
                    leading: Icon(Icons.lock),
                    value: themeChange.appLock,
                    subtitle: Text(
                      "برای ورود به اپلیکیشن میتوانید از حسگر اثرانگشت و تشخیص صورت استفاده کنید",
                      style: TextStyle(fontFamily: mainFont),
                    ),
                    onChanged: (bool lockState) {
                      if (appLockPassword == null) {
                        Navigator.pushNamed(context, savingAppLockPass);
                        setState(() {
                          appLockPassword = "Somethings is right!";
                        });
                      } else {
                        delAppLock();
                        themeChange.appLock = false;
                        setState(() {
                          appLockPassword = null;
                        });
                      }
                    },
                    title: Text(
                      "فعال سازی بایومتریک",
                      style: TextStyle(fontFamily: mainFont, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
