/// This Main file that will be used to run the program.
/// Some things use in this here for loading somethings at background.
/// The most important things is all Provider state manager at start in multi-provider.
/// Next things is DarkTheme Provider as consumer in entir program.
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:payausers/Screens/static_reserve_view.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/instant_reserve_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/public_parking_model.dart';
import 'package:payausers/providers/reserve_weeks_model.dart';
import 'package:payausers/providers/reservers_by_week_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/server_base_calendar_model.dart';
import 'package:payausers/providers/server_base_static_reserve_calendar_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
import 'package:payausers/providers/terms_of_service_model.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Model/theme_color.dart';
import 'package:provider/provider.dart';
import 'package:root_detector/root_detector.dart';

// Screens
import 'Screens/ForgetPasswordTabs/recover_password.dart';
import 'Screens/adding_plate_intro.dart';
import 'package:payausers/Screens/Tabs/reserved_tab.dart';
import 'package:payausers/Screens/read_terms_of_service.dart';
import 'package:payausers/Screens/checking_access.dart';
import 'package:payausers/Screens/add_plate_guide_view.dart';
import 'package:payausers/Screens/reserve_guide_view.dart';
import 'package:payausers/Screens/family_plate.dart';
import 'package:payausers/Screens/mine_plate.dart';
import 'package:payausers/Screens/ForgetPasswordTabs/otp_Screen.dart';
import 'package:payausers/Screens/parking_type_view.dart';
import 'package:payausers/Screens/other_plate_view.dart';
import 'Screens/auth_entered_users.dart';
import 'package:payausers/Screens/forget_password.dart';
import 'Screens/check_connection.dart';
import 'Screens/enable_app_lock.dart';
import 'Screens/splash_screen.dart';
import 'Screens/intro.dart';
import 'Screens/login_page.dart';
import 'package:payausers/Screens/two_factor_auth.dart';
import 'Screens/confirm_info.dart';
import 'Screens/theme_mode_selector.dart';
import 'Screens/maino.dart';
import 'Screens/settings.dart';
import 'Screens/change_password.dart';
import 'Screens/login_checkout.dart';
import 'package:payausers/Screens/set_biometric.dart';
import 'package:payausers/Screens/terms_of_service_page.dart';

// Init Firebase Cloud Messaging system before start main
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Adding Dark theme provider to have provider changer theme
DarkThemeProvider themeChangeProvider = DarkThemeProvider();

/// This two value notifier is used to define the badge state.
///
/// We have two Badge value number that we define it as ValueNotifier.
/// - Reserver submit from admin panel to notify user it reserve submitted.
/// - Plate added from admin panel to notify user it plate added.
/// This notifiers have a value to separate notification from other.
/// The key of this notifier is target.
/// Value of that is (0) => Reserver submit, (1) => Plate added.
ValueNotifier<int> userPlateNotiCounter =
    ValueNotifier(themeChangeProvider.userPlateNumNotif);
ValueNotifier<int> userInstantReserveCounter =
    ValueNotifier(themeChangeProvider.instantUserReserve);

// Set notification number in provider user number notification Specification.
void setFCMNotifier(targetPoint) {
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

// Background Worker
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background Message ${message.messageId}");
  print(message.notification.title);
  print(message.notification.body);
  print(message.data["target"]);

  // Set notification number in provider (user number notification) Specific
  setFCMNotifier(message.data["target"]);

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
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "id",
  "name",
  "description",
  importance: Importance.high,
);

// SSL Pining apply
sslPining() async {
  SecurityContext(withTrustedRoots: false);
  ByteData data = await rootBundle.load("assets/raw/certificate.pem");
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());
}

void main() async {
  sslPining();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Root and emulator detection function
  // rootDetector();
  runApp(MyApp());
}

// this function, is a root detector function by root_detector package from beer root detector.
///
/// root_detector is nativly for java by beer root github repo.
/// In flutter we will use from root_detector package.
/// In this function we check if machine was root or not.
/// If machine (phone) was root, the application will close automatically from the phone.
/// GPhone emulator all of avd is root, so we can use from that for emulator detector.
Future<void> rootDetector() async {
  try {
    await RootDetector.isRooted(busyBox: false, ignoreSimulator: false)
        .then((result) {
      return result ? exit(0) : null;
    });
  } on PlatformException {
    print("Failed to get root status");
    return null;
  }
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
      setFCMNotifier(message.data["target"]);

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
            iOS: IOSNotificationDetails(
              subtitle: notification.body,
            ),
          ),
        );
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
            ChangeNotifierProvider<TermsOfServiceModel>(
              create: (_) => TermsOfServiceModel(),
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
            ),
            ChangeNotifierProvider<ServerBaseCalendarModel>(
              create: (_) => ServerBaseCalendarModel(),
            ),
            ChangeNotifierProvider<ServerBaseStaticReserveCalendarModel>(
              create: (_) => ServerBaseStaticReserveCalendarModel(),
            ),
            ChangeNotifierProvider<PublicParkingModel>(
              create: (_) => PublicParkingModel(),
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget child) {
              SystemChrome.setSystemUIOverlayStyle(themeChangeProvider.darkTheme
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark);
              return LiquidApp(
                materialApp: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  supportedLocales: [
                    const Locale('fa', 'IR'),
                  ],
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    // Uncomment when we want use app in different rtl like English base languages
                    // GlobalWidgetsLocalizations.delegate,
                  ],
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
                    '/checkConnection': (context) => CheckConnection(),
                    '/checkingAccess': (context) => CheckingAccess(),
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
                    '/reservedTab': (context) => ReservedTab(),
                    '/addPlateGuideView': (context) => AddPlateGuideView(),
                    '/reserveGuideView': (context) => ReserveGuideView(),
                    '/addingPlateIntro': (context) => AddingPlateIntro(),
                    '/addingMinePlate': (context) => MinePlateView(),
                    '/addingFamilyPage': (context) => FamilyPlateView(),
                    '/addingOtherPlate': (context) => OtherPageView(),
                    '/settings': (context) => SettingsPage(),
                    '/readTermsOfService': (context) => ReadTermsOfService(),
                    '/changePassword': (context) => ChangePassPage(),
                    '/setBiometric': (context) => SettingBiometric(),
                    '/savingAppLockPass': (context) => SavingAppLock(),
                    '/staticReserveView': (context) => StaticReserveView(),
                    '/selectParkingType': (context) => ParkingTypeView(),
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
