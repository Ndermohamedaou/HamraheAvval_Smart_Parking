import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    void navigatedToLogin() => Navigator.pushNamed(context, '/termsAndLicense');
    return Scaffold(
        body: MainIntro(),
        bottomNavigationBar: BottomButton(
            color: mainCTA, text: nextLevel1, onTapped: navigatedToLogin));
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
                width: 300,
                child: Image.asset(
                  "assets/images/meaning_intro_vector.png",
                  width: 300,
                ),
              ),
              SizedBox(height: 20),
              Text(
                introTitle1Text,
                style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    color: titleTextColor,
                    fontWeight: FontWeight.normal,
                    fontSize: titleTextSize),
              ),
              SizedBox(height: 7),
              Text(
                "به اپلیکیشن پارکینگ هوشمند همراه اول خوش آمدید",
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontWeight: FontWeight.normal,
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
