import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/gettingLogin.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/view/introPages/intro.dart';
import 'package:securityapp/view/introPages/themeChange.dart';
import 'package:securityapp/widgets/alert.dart';
import 'package:securityapp/widgets/bottomBtn.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';

import 'introPages/login.dart';
import 'introPages/terms_of_service.dart';

int pageIndex = 0;
PageController _pageController;

// Login
var protectedPassword;
String personalCode = "";
String password = "";
IconData showMePass = Icons.remove_red_eye;
// info error handle
dynamic emptyTextFieldErrPersCode = null;
dynamic emptyTextFieldErrPassword = null;
// Add Auth Controller Class
AuthUsers auth = AuthUsers();
// Checked Terms
bool acceptedTerms = false;
// Is Login?
bool isLogin = false;

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
    personalCode = "";
    password = "";
    emptyTextFieldErrPersCode = null;
    emptyTextFieldErrPassword = null;
    showMePass = Icons.remove_red_eye;
    protectedPassword = true;
    acceptedTerms = false;
    isLogin = false;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // If First visit is true
    void updateStaffInfo(token) {
      Navigator.pushNamed(context, confirmationRoute, arguments: token);
    }

    // If First visit is false
    void staffWillNavigateBuildings(token) {
      Navigator.pushNamed(context, buildingsRoute, arguments: token);
    }

    void loginTo({personalCode, password}) async {
      if (personalCode != "" && password != "") {
        setState(() => isLogin = true);
        Map initUser =
            await auth.gettingLogin(persCode: personalCode, pass: password);
        // Invalid (Validation Process Check)
        print(initUser);
        if (initUser["error"] != null) {
          setState(() => isLogin = false);
          showStatusInCaseOfFlush(
            context: context,
            title: initUser["error"]["title"],
            msg: initUser["error"]["desc"],
            icon: Icons.supervised_user_circle,
            iconColor: Colors.red,
          );
        } else {
          if (initUser['role'] == "security" || initUser['role'] == "admin") {
            if (initUser["first_visit"]) {
              setState(() => isLogin = false);
              updateStaffInfo(initUser["token"]);
            } else {
              setState(() => isLogin = false);
              staffWillNavigateBuildings(initUser["token"]);
            }
          } else {
            setState(() => isLogin = false);
            securityAlertLogin(
              context: context,
              onPressed: () => Navigator.pop(context),
            );
          }
        }
      } else {
        setState(() {
          isLogin = false;
          emptyTextFieldErrPersCode = emptyTextFieldMsg;
          emptyTextFieldErrPassword = emptyTextFieldMsg;
        });
      }
    }

    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        body: PageView(
          onPageChanged: (index) => setState(() => pageIndex = index),
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Intro(),
            ThemeChange(
              lightThemePressed: () =>
                  setState(() => themeChange.darkTheme = false),
              darkThemePressed: () =>
                  setState(() => themeChange.darkTheme = true),
            ),
            Terms(
              themeChange: themeChange.darkTheme,
              acceptedTerms: acceptedTerms,
              setCheckTerms: (bool value) =>
                  setState(() => acceptedTerms = value),
            ),
            LoginMain(
              personalCode: personalCode,
              password: password,
              onChangePersCode: (onChangePersCode) {
                setState(() {
                  emptyTextFieldErrPersCode = null;
                  personalCode = onChangePersCode;
                });
              },
              onChangedPassword: (onChangePassword) {
                setState(() {
                  emptyTextFieldErrPassword = null;
                  password = onChangePassword;
                });
              },
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
              emptyPersCode: emptyTextFieldErrPersCode,
              emptyPassword: emptyTextFieldErrPassword,
              showMePass: showMePass,
              protectedPassword: protectedPassword,
            ),
          ],
        ),
        bottomNavigationBar: BottomButton(
          color: mainCTA,
          loadingState: isLogin,
          onTapped: () {
            pageIndex == 3
                ? loginTo(personalCode: personalCode, password: password)
                : nextPageIndex();
          },
          text: pageIndex == 3
              ? loginText
              : pageIndex == 2
                  ? !acceptedTerms
                      ? "الزام در پذیرش ضوابط"
                      : loginText
                  : next,
        ),
      ),
    );
  }

  void nextPageIndex() {
    if (pageIndex == 2 && acceptedTerms) {
      setState(() => pageIndex += 1);
      _pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 600), curve: Curves.decelerate);
    } else if (pageIndex != 2) {
      setState(() => pageIndex += 1);
      _pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 600), curve: Curves.decelerate);
    } else if (pageIndex == 2 && !acceptedTerms) {
      null;
    }
  }
}
