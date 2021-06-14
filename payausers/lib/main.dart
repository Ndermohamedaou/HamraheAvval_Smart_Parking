import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Model/ThemeColor.dart';
import 'package:provider/provider.dart';

// Screens
import 'Screens/ForgetPasswordTabs/recoverPassword.dart';
import 'Screens/addingPlateIntro.dart';
import 'package:payausers/Screens/familyPage.dart';
import 'package:payausers/Screens/minePlate.dart';
import 'package:payausers/Screens/ForgetPasswordTabs/OTPSection.dart';
import 'package:payausers/Screens/otherPlateView.dart';
import 'Screens/auth_entered_users.dart';
import 'package:payausers/Screens/forgetPassword.dart';
import 'Screens/enableAppLock.dart';
import 'Screens/splashScreen.dart';
import 'Screens/intro.dart';
import 'Screens/loginPage.dart';
import 'package:payausers/Screens/two_factor_auth.dart';
import 'Screens/confirmInfo.dart';
import 'Screens/themeModeSelector.dart';
import 'Screens/maino.dart';
import 'Screens/settings.dart';
import 'Screens/changePassword.dart';
import 'Screens/loginCheckout.dart';
import 'Screens/reservePageEdit.dart';
import 'package:payausers/Screens/set_biometric.dart';
import 'package:payausers/Screens/termsOfServicePage.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Adding Dark theme provider to have provider changer theme
DarkThemeProvider themeChangeProvider = DarkThemeProvider();

ValueNotifier<int> userPlateNotiCounter =
    ValueNotifier(themeChangeProvider.userPlateNumNotif);
ValueNotifier<int> userInstantReserveCounter =
    ValueNotifier(themeChangeProvider.instantUserReserve);

// Set notification number in provider (user number notification) Specific
void setFCMNotifire(targetPoint) {
  if (targetPoint == "3") {
    userPlateNotiCounter.value = themeChangeProvider.userPlateNumNotif == 0
        ? 0
        : themeChangeProvider.userPlateNumNotif;
    userPlateNotiCounter.value++;
    userPlateNotiCounter.notifyListeners();
    themeChangeProvider.userPlateNumNotif = userPlateNotiCounter.value;
  } else if (targetPoint == "2") {
    userInstantReserveCounter.value =
        themeChangeProvider.instantUserReserve == 0
            ? 0
            : themeChangeProvider.instantUserReserve;
    userInstantReserveCounter.value++;
    userInstantReserveCounter.notifyListeners();
    themeChangeProvider.instantUserReserve = userInstantReserveCounter.value;
  }
}

// Backgroud Worker
Future<void> _firebaseMessaginBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background Message ${message.messageId}");
  print(message.notification.title);
  print(message.notification.body);
  print(message.data["target"]);

  // Set notification number in provider (user number notification) Specific
  setFCMNotifire(message.data["target"]);

  flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification.title,
      message.notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          icon: '@mipmap/ic_launcher',
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "id",
  "name",
  "description",
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Getting Current App Theme (dark or light)
    getCurrentAppTheme();
    getCurrentAppLockPassStatus();
    getCurrentAppUserPlateNotifNumber();

    var initializationAndroidSetting =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    // iOS Config in permission and did receive
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {});

    // Set config for Android and iOS
    var initializationSettings = InitializationSettings(
      android: initializationAndroidSetting,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // Getting token
    gettingDeviceToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // Set notification number in provider (user number notification) Specific
      setFCMNotifire(message.data["target"]);

      if (notification != null || android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
  }

  void gettingDeviceToken() async {
    try {
      final userDeviceToken = await FirebaseMessaging.instance.getToken();
      print("DUT ====> $userDeviceToken");
    } catch (e) {
      print("Error in Getting Token => $e");
    }
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  void getCurrentAppLockPassStatus() async {
    themeChangeProvider.appLock =
        await themeChangeProvider.darkThemePreferences.getLockState();
  }

  void getCurrentAppUserPlateNotifNumber() async {
    themeChangeProvider.userPlateNumNotif = await themeChangeProvider
        .darkThemePreferences
        .getUserPlateNotifNumber();
  }

  void getCurrentAppUserInstantReserveNotifNumber() async {
    themeChangeProvider.instantUserReserve = await themeChangeProvider
        .darkThemePreferences
        .getInstantUserNotifNumber();
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
                    '/forgetPassword': (context) => ForgetPasswordPage(),
                    '/otpSection': (context) => OTPSubmission(),
                    '/recoverPassword': (context) => RecoverPassword(),
                    '/login': (context) => LoginPage(),
                    '/2factorAuth': (context) => TwoFactorAuthScreen(),
                    '/confirm': (context) => ConfirmScreen(),
                    '/loginCheckout': (context) => LoginCheckingoutPage(),
                    '/localAuth': (context) => LocalAuthEnter(),
                    '/dashboard': (context) => Maino(),
                    '/addingPlateIntro': (context) => AddingPlateIntro(),
                    '/addingMinPlate': (context) => MinPlateView(),
                    '/addingFamilyPage': (context) => FamilyPlateView(),
                    '/addingOtherPlate': (context) => OtherPageView(),
                    '/settings': (context) => SettingsPage(),
                    '/changePassword': (context) => ChangePassPage(),
                    '/reserveEditaion': (context) => ReserveEditaion(),
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
