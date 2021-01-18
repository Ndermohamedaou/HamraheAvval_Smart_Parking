import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:provider/provider.dart';
import '../Classes/ThemeColor.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    void navigatedToLogin() => Navigator.pushNamed(context, '/themeSelector');
    return Scaffold(
        body: MainIntro(),
        bottomNavigationBar:
            BottomButton(text: nextLevel1, ontapped: navigatedToLogin));
  }
}

class MainIntro extends StatefulWidget {
  @override
  _MainIntroState createState() => _MainIntroState();
}

class _MainIntroState extends State<MainIntro> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Image.asset("assets/images/meaning_intro_vector.png"),
              ),
              SizedBox(height: 20),
              Text(
                introTitle1Text,
                style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    color: titleTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: titleTextSize),
              ),
              SizedBox(height: 7),
              Text(
                "به اپلیکیشن کاربران پایا خوش آمدید",
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: subTitleSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
