import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:provider/provider.dart';

String appLockPassword = null;

class SettingBiometric extends StatefulWidget {
  @override
  _SettingBiometricState createState() => _SettingBiometricState();
}

class _SettingBiometricState extends State<SettingBiometric> {
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
    AppLocalizations t = AppLocalizations.of(context);

    void delAppLock() async {
      final lStorage = FlutterSecureStorage();
      await lStorage.delete(key: "local_lock");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          t.translate("localLock.setLock"),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: themeChange.darkTheme ? darkBar : lightBar,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: themeChange.darkTheme ? darkBar : lightBar,
                  ),
                  child: ListTileSwitch(
                    leading: Icon(Icons.lock),
                    value: themeChange.appLock,
                    subtitle: Text(
                      t.translate("localLock.info"),
                      style: TextStyle(
                        fontFamily: mainFaFontFamily,
                      ),
                    ),
                    onChanged: (bool lockState) {
                      if (appLockPassword == null) {
                        Navigator.pushNamed(context, "/savingAppLockPass");
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
                      t.translate("localLock.enable"),
                      style:
                          TextStyle(fontFamily: mainFaFontFamily, fontSize: 15),
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
