import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/view/maino.dart';
import 'package:securityapp/view/splashScreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final mainTitleLogo = themeChange.darkTheme
        ? "assets/images/Titile_Logo_Mark_dark.png"
        : "assets/images/Titile_Logo_Mark_light.png";
    return Scaffold(
      body: CustomSplash(
        imagePath: mainTitleLogo,
        backGroundColor: themeChange.darkTheme ? darkBgColor : lightBgColor,
        animationEffect: 'zoom-out',
        logoSize: 100,
        home: SplashScreen(),
        // customFunction: navigatedToRoot,
        duration: 2000,
        type: CustomSplashType.StaticDuration,
        // outputAndHome: op,
      ),
    );
  }
}
