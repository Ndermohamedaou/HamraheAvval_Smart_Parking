import 'package:liquid_ui/liquid_ui.dart';

import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:provider/provider.dart';

// Screens
import 'Screens/addingPlateIntro.dart';
import 'package:payausers/Screens/familyPage.dart';
import 'package:payausers/Screens/minePlate.dart';
import 'package:payausers/Screens/otherPlateView.dart';
import 'Screens/auth_entered_users.dart';
import 'Screens/enableAppLock.dart';
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
import 'package:payausers/Screens/reserveView.dart';
import 'package:payausers/Screens/set_biometric.dart';
import 'package:payausers/Screens/termsOfServicePage.dart';

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
    // Getting Current App Theme (dark or light)
    getCurrentAppTheme();
    getCurrentAppLockPassStatus();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  void getCurrentAppLockPassStatus() async {
    themeChangeProvider.appLock =
        await themeChangeProvider.darkThemePreferences.getLockState();
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
                  // For set app fontSize by default size without system fontSize
                  builder: (BuildContext context, Widget child) {
                    final MediaQueryData data = MediaQuery.of(context);
                    return MediaQuery(
                      data: data.copyWith(textScaleFactor: 1),
                      child: child,
                    );
                  },
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  initialRoute: '/splashScreen',
                  routes: {
                    '/splashScreen': (context) => SplashScreen(),
                    '/': (context) => IntroPage(),
                    '/themeSelector': (context) => ThemeModeSelectorPage(),
                    '/termsAndLicense': (context) => TermsOfServiceView(),
                    '/login': (context) => LoginPage(),
                    '/confirm': (context) => ConfirmScreen(),
                    '/loginCheckout': (context) => LoginCheckingoutPage(),
                    '/localAuth': (context) => LocalAuthEnter(),
                    '/dashboard': (context) => Maino(),
                    '/addReserve': (context) => ReservedTab(),
                    '/myPlate': (context) => MYPlateScreen(),
                    '/addingPlateIntro': (context) => AddingPlateIntro(),
                    '/addingMinPlate': (context) => MinPlateView(),
                    '/addingFamilyPage': (context) => FamilyPlateView(),
                    '/addingOtherPlate': (context) => OtherPageView(),
                    '/settings': (context) => SettingsPage(),
                    '/changePassword': (context) => ChangePassPage(),
                    '/reserveEditaion': (context) => ReserveEditaion(),
                    '/addUserplateAlternative': (context) =>
                        AddUserPlatAlternative(),
                    '/changeEmail': (context) => ModifyUserEmail(),
                    '/listLengthSettingPage': (context) => ChangePageIndex(),
                    '/setBiometric': (context) => SettingBiometric(),
                    '/savingAppLockPass': (context) => SavingAppLock(),
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
