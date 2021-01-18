import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:provider/provider.dart';
import "package:payausers/ExtractedWidgets/ThemeModeComponent.dart";

class ThemeModeSelectorPage extends StatefulWidget {
  @override
  _ThemeModeSelectorPageState createState() => _ThemeModeSelectorPageState();
}

class _ThemeModeSelectorPageState extends State<ThemeModeSelectorPage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    // Navigatoed to Login
    void goToNext() => Navigator.pushNamed(context, '/login');
    // Checked if you are have Dark or Light Mode
    const String lightLottie = "assets/lottie/36236-sun-icon.json";
    const String darkLottie = "assets/lottie/darkModeLottie.json";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    themeChangeText,
                    style: TextStyle(
                        color: titleTextColor,
                        fontFamily: mainFaFontFamily,
                        fontSize: titleTextSize,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      themeMsg,
                      style:
                          TextStyle(fontFamily: mainFaFontFamily, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ThemeModeComponent(
                        lottieFile: lightLottie,
                        onActive: () => themeChange.darkTheme = false,
                        color: "#197EFF"),
                    ThemeModeComponent(
                        lottieFile: darkLottie,
                        onActive: () => themeChange.darkTheme = true,
                        color: "#0B1B26"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        text: nextLevel1,
        ontapped: goToNext,
      ),
    );
  }
}
