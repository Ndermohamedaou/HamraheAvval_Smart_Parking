import 'package:liquid_ui/liquid_ui.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/Screens/reserveView.dart';
import 'package:provider/provider.dart';

// Screens
import 'Screens/splashScreen.dart';
import 'Screens/intro.dart';
import 'Screens/loginPage.dart';
import 'Screens/confirmInfo.dart';
import 'Screens/themeModeSelector.dart';
import 'Screens/maino.dart';
import 'Screens/addUserPlateAlternative.dart';
import 'Screens/myPlate.dart';
import 'Screens/settings.dart';
import 'Screens/changePassword.dart';
import 'Screens/loginCheckout.dart';
import 'Screens/reservePageEdit.dart';
import 'Screens/changeUserEmail.dart';
import 'Screens/pageLengthIndex.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Adding Dark theme provider to have provider changer theme
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil().init(constraints, orientation);
        return ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
          child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget child) {
              SystemChrome.setSystemUIOverlayStyle(themeChangeProvider.darkTheme
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark);
              return LiquidApp(
                materialApp: MaterialApp(
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  initialRoute: '/splashScreen',
                  routes: {
                    '/splashScreen': (context) => SplashScreen(),
                    '/': (context) => IntroPage(),
                    '/themeSelector': (context) => ThemeModeSelectorPage(),
                    '/login': (context) => LoginPage(),
                    '/confirm': (context) => ConfirmScreen(),
                    '/loginCheckout': (context) => LoginCheckingoutPage(),
                    '/dashboard': (context) => Maino(),
                    '/addReserve': (context) => ReservedTab(),
                    '/myPlate': (context) => MYPlateScreen(),
                    '/settings': (context) => SettingsPage(),
                    '/changePassword': (context) => ChangePassPage(),
                    '/reserveEditaion': (context) => ReserveEditaion(),
                    '/addUserplateAlternative': (context) =>
                        AddUserPlatAlternative(),
                    '/changeEmail': (context) => ModifyUserEmail(),
                    '/listLengthSettingPage': (context) => ChangePageIndex(),
                  },
                ),
              );
            },
          ),
        );
      });
    });
  }
}
