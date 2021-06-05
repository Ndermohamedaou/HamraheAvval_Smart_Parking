import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';

// Model Providers
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/traffics_model.dart';

// Screens
import 'Screens/addingPlateIntro.dart';
import 'Screens/familyPage.dart';
import 'Screens/loadingChangeAvatar.dart';
import 'Screens/minePlate.dart';
import 'Screens/otherPlateView.dart';
import 'Screens/splashScreen.dart';
import 'package:payausers/Screens/two_factor_auth.dart';
import 'package:payausers/Screens/forgetPassword.dart';
import 'package:payausers/Screens/ForgetPasswordTabs/OTPSection.dart';
import 'package:payausers/Screens/ForgetPasswordTabs/recoverPassword.dart';
import 'package:payausers/Screens/termsOfServicePage.dart';
import 'Screens/intro.dart';
import 'Screens/loginPage.dart';
import 'Screens/confirmInfo.dart';
import 'Screens/themeModeSelector.dart';
import 'Screens/maino.dart';
import 'Screens/settings.dart';
import 'Screens/changePassword.dart';
import 'Screens/loginCheckout.dart';
import 'Screens/reservePageEdit.dart';
import 'Screens/pageLengthIndex.dart';

void main() async {
  runApp(MyApp());
  FirebaseMessaging.instance.getToken().then(print);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// Adding Dark theme provider to have provider changer theme
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  ValueNotifier<int> userPlateNotiCounter;
  ValueNotifier<int> userInstantReserveCounter;
  @override
  void initState() {
    super.initState();

    userPlateNotiCounter = ValueNotifier(themeChangeProvider.userPlateNumNotif);
    userInstantReserveCounter =
        ValueNotifier(themeChangeProvider.instantUserReserve);

    getCurrentAppTheme();
    firebaseOnMessage();
    onFirebaseOpenedApp();
  }

  void onFirebaseOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.notification.title);
    });
  }

  void firebaseOnMessage() {
    FirebaseMessaging.onMessage.listen((msg) {
      print(msg.notification.title);
      print(msg.notification.body);
      print(msg.data["target"]);

      if (msg.data["target"] == "3") {
        userPlateNotiCounter.value = themeChangeProvider.userPlateNumNotif == 0
            ? 0
            : themeChangeProvider.userPlateNumNotif;
        userPlateNotiCounter.value++;
        userPlateNotiCounter.notifyListeners();
        themeChangeProvider.userPlateNumNotif = userPlateNotiCounter.value;
      } else if (msg.data["target"] == "2") {
        userInstantReserveCounter.value =
            themeChangeProvider.instantUserReserve == 0
                ? 0
                : themeChangeProvider.instantUserReserve;
        userInstantReserveCounter.value++;
        userInstantReserveCounter.notifyListeners();
        themeChangeProvider.instantUserReserve =
            userInstantReserveCounter.value;
      }
    });
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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
            ChangeNotifierProvider<AvatarModel>(
              create: (_) {
                return AvatarModel();
              },
            ),
            ChangeNotifierProvider<ReservesModel>(
              create: (_) {
                return ReservesModel();
              },
            ),
            ChangeNotifierProvider<TrafficsModel>(
              create: (_) {
                return TrafficsModel();
              },
            ),
            ChangeNotifierProvider<PlatesModel>(
              create: (_) {
                return PlatesModel();
              },
            )
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget child) {
              SystemChrome.setSystemUIOverlayStyle(themeChangeProvider.darkTheme
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark);
              return MaterialApp(
                // For set app fontSize by default size without system fontSize
                builder: (BuildContext context, Widget child) {
                  final MediaQueryData data = MediaQuery.of(context);
                  return MediaQuery(
                    data: data.copyWith(textScaleFactor: 1),
                    child: child,
                  );
                },
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                initialRoute: '/splashScreen',
                routes: {
                  '/splashScreen': (context) => SplashScreen(),
                  '/': (context) => IntroPage(),
                  '/themeSelector': (context) => ThemeModeSelectorPage(),
                  '/termsAndLicense': (context) => TermsOfServiceView(),
                  '/forgetPassword': (context) => ForgetPasswordPage(),
                  '/otpSection': (context) => OTPSubmission(),
                  '/recoverPassword': (context) => RecoverPassword(),
                  '/login': (context) => LoginPage(),
                  '/2factorAuth': (context) => TwoFactorAuthScreen(),
                  '/confirm': (context) => ConfirmScreen(),
                  '/loginCheckout': (context) => LoginCheckingoutPage(),
                  '/dashboard': (context) => Maino(),
                  '/addingPlateIntro': (context) => AddingPlateIntro(),
                  '/addingMinPlate': (context) => MinPlateView(),
                  '/addingFamilyPage': (context) => FamilyPlateView(),
                  '/addingOtherPlate': (context) => OtherPageView(),
                  '/settings': (context) => SettingsPage(),
                  '/changePassword': (context) => ChangePassPage(),
                  '/reserveEditaion': (context) => ReserveEditaion(),
                  '/listLengthSettingPage': (context) => ChangePageIndex(),
                  '/loadedTimeToChangeAvatar': (context) =>
                      LoadingChangeAvatar(),
                },
              );
            },
          ),
        );
      });
    });
  }
}
