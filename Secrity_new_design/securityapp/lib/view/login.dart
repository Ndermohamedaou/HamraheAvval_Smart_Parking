import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/view/introPages/intro.dart';
import 'package:securityapp/view/introPages/themeChange.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/bottomBtn.dart';
import 'package:securityapp/widgets/textField.dart';
import 'package:sizer/sizer.dart';

import 'introPages/login.dart';

int pageIndex = 0;
var _pageController = PageController();

// Login
var protectedPassword;
String personalCode = "";
String password = "";
IconData showMePass = Icons.remove_red_eye;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    pageIndex = 0;
    _pageController = PageController();
    protectedPassword = true;

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        body: PageView(
          onPageChanged: (index) => setState(() => pageIndex = index),
          controller: _pageController,
          children: [
            Intro(),
            ThemeChange(
              lightThemePressed: () =>
                  setState(() => themeChange.darkTheme = false),
              darkThemePressed: () =>
                  setState(() => themeChange.darkTheme = true),
            ),
            LoginMain(
              personalCode: personalCode,
              password: password,
              showMePass: showMePass,
              protectedPassword: protectedPassword,
            ),
          ],
        ),
        bottomNavigationBar: BottomButton(
          color: mainCTA,
          onTapped: () {
            pageIndex == 2 ? login() : nextPageIndex();
          },
          text: pageIndex == 2 ? loginText : next,
        ),
      ),
    );
  }

  void nextPageIndex() {
    setState(() => pageIndex += 1);
    _pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 600), curve: Curves.decelerate);
  }

  void login() {
    Navigator.pushNamed(context, mainoRoute);
  }
}
