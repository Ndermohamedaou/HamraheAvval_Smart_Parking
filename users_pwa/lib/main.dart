import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:payausers/Screens/Tabs/reservedTab.dart';
import 'package:payausers/config_nonweb.dart';
import 'package:payausers/providers/instant_reserve_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
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
import 'Screens/familyPlate.dart';
import 'Screens/loadingChangeAvatar.dart';
import 'Screens/add_plate_guide_view.dart';
import 'Screens/reserve_guide_view.dart';
import 'Screens/minePlate.dart';
import 'Screens/otherPlateView.dart';
import 'Screens/splashScreen.dart';
import 'Screens/two_factor_auth.dart';
import 'Screens/forgetPassword.dart';
import 'Screens/ForgetPasswordTabs/OTPSection.dart';
import 'Screens/ForgetPasswordTabs/recoverPassword.dart';
import 'Screens/termsOfServicePage.dart';
import 'Screens/intro.dart';
import 'Screens/loginPage.dart';
import 'Screens/confirmInfo.dart';
import 'Screens/themeModeSelector.dart';
import 'Screens/maino.dart';
import 'Screens/settings.dart';
import 'Screens/readTermsOfService.dart';
import 'Screens/changePassword.dart';
import 'Screens/loginCheckout.dart';
import 'Screens/pageLengthIndex.dart';

void main() async {
  configApp();
  runApp(MyApp());

  /// Getting Device Token of every user from their device
  ///
  /// I will send it to server app, and server app will save it as an index of
  /// user_device_token list. This most important from this list is sending notification to which device?
  /// If my device_token list was 3 index, notification will send to entire of this device tokens and 3 device will
  /// have notification from notification center.
  FirebaseMessaging.instance.getToken().then(
      print); // I want show it from terminal maybe i want use that in my API
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Adding Dark theme provider to have provider changer theme
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  // userPlateNotiCount
  ValueNotifier<int> userPlateNotifCounter;
  ValueNotifier<int> userInstantReserveCounter;

  @override
  void initState() {
    super.initState();

    userPlateNotifCounter =
        ValueNotifier(themeChangeProvider.userPlateNumNotif);
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
    /// This two value notifier is used to define the badge state.
    ///
    /// We have two Badge value number that we define it as ValueNotifier.
    /// - Reserver submit from admin panel to notify user it reserve submitted.
    /// - Plate added from admin panel to notify user it plate added.
    /// This notifiers have a value to separate notification from other.
    /// The key of this notifier is target.
    /// Value of that is (0) => Reserver submit, (1) => Plate added.
    FirebaseMessaging.onMessage.listen((msg) {
      print(msg.notification.title);
      print(msg.notification.body);
      print(msg.data["target"]);

      if (msg.data["target"] == "3") {
        /// Check if user doesn't see notification badge inside of App
        userPlateNotifCounter.value = themeChangeProvider.userPlateNumNotif == 0
            ? 0
            : themeChangeProvider.userPlateNumNotif;
        userPlateNotifCounter.value++;
        userPlateNotifCounter.notifyListeners();
        themeChangeProvider.userPlateNumNotif = userPlateNotifCounter.value;
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
    /// Getting Current theme provider from provider of darktheme
    ///
    /// It will be use to change theme of app from consumer side of app.
    /// Because app had a state of dark theme and light theme.
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
            ChangeNotifierProvider<DarkThemeProvider>(
              create: (_) {
                return themeChangeProvider;
              },
            ),
            ChangeNotifierProvider<StaffInfoModel>(
              create: (_) => StaffInfoModel(),
            ),
            ChangeNotifierProvider<AvatarModel>(
              create: (_) => AvatarModel(),
            ),
            ChangeNotifierProvider<ReservesModel>(
              create: (_) => ReservesModel(),
            ),
            ChangeNotifierProvider<ReservesByWeek>(
              create: (_) => ReservesByWeek(),
            ),
            ChangeNotifierProvider<ReserveWeeks>(
              create: (_) => ReserveWeeks(),
            ),
            ChangeNotifierProvider<TrafficsModel>(
              create: (_) => TrafficsModel(),
            ),
            ChangeNotifierProvider<PlatesModel>(
              create: (_) => PlatesModel(),
            ),
            ChangeNotifierProvider<InstantReserveModel>(
              create: (_) => InstantReserveModel(),
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
                debugShowCheckedModeBanner: false,
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
                  '/addPlateGuideView': (context) => AddPlateGuideView(),
                  '/reserveGuideView': (context) => ReserveGuideView(),
                  '/reservedTab': (context) => ReservedTab(),
                  '/addingPlateIntro': (context) => AddingPlateIntro(),
                  '/addingMinePlate': (context) => MinePlateView(),
                  '/addingFamilyPlate': (context) => FamilyPlateView(),
                  '/addingOtherPlate': (context) => OtherPageView(),
                  '/settings': (context) => SettingsPage(),
                  '/readTermsOfService': (context) => ReadTermsOfService(),
                  '/changePassword': (context) => ChangePassPage(),
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
