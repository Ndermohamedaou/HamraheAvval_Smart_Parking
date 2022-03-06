import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/localization/app_localization.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

AppLocalizations t;

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    // Getting Strings
    t = AppLocalizations.of(context);

    void navigatedToLogin() => Navigator.pushNamed(context, '/themeSelector');
    return Scaffold(
        body: MainIntro(),
        bottomNavigationBar: BottomButton(
            color: mainCTA,
            text: t.translate("navigation.next"),
            onTapped: navigatedToLogin));
  }
}

class MainIntro extends StatefulWidget {
  @override
  _MainIntroState createState() => _MainIntroState();
}

class _MainIntroState extends State<MainIntro> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/images/meaning_intro_vector.png",
                    width: 300,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  t.translate("appName"),
                  style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      color: mainCTA,
                      fontWeight: FontWeight.bold,
                      fontSize: titleTextSize),
                ),
                SizedBox(height: 7),
                Text(
                  t.translate("welcomeAppIntro"),
                  style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    fontSize: subTitleSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
