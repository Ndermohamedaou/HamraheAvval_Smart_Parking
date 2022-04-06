import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/provider/abuse_warning_model.dart';
import 'package:securityapp/provider/term_of_service_model.dart';
import 'package:securityapp/view/recover_password_view.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';
import 'model/classes/ThemeColor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:root_detector/root_detector.dart';

// Screens
import 'view/splashScreen.dart';
import 'view/login.dart';
import 'view/forget_password_view.dart';
import 'view/otp_screen.dart';
import 'view/maino.dart';
import 'view/searchingPlate.dart';
import 'view/searchingSlot.dart';
import 'view/searchingByCamera.dart';
import 'view/searchingByPersonalCode.dart';
import 'view/searchResults.dart';
import 'view/entryCheck.dart';
import 'view/exitCheck.dart';
import 'view/ImageCheckingTime.dart';
import 'view/profile.dart';
import 'view/buildingForUsers.dart';
import 'view/confirmation.dart';
import 'view/bookmarked.dart';
import 'view/imgProcessResult.dart';
import 'view/editePage.dart';
import 'view/settingsView.dart';
import 'view/setAppLock.dart';
import 'view/savingAppLockPass.dart';
import 'view/localAuthEnter.dart';
import 'view/readTermsOfService.dart';

void main() {
  runApp(MyApp());
  // Future use
  // connectSocket();
  // Getting start for checking if device was root app doest open.
  // rootDetector();
}

// this function, is a root detector function by root_detector package from beer root detector.
///
/// root_detector is natively for java by beer root github repo.
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
    // print("Failed to get root status");
    return null;
  }
}

// Flutter local notification
FlutterLocalNotificationsPlugin localNotif;

// for set socket settings with nspc and endpoint in a channel
void connectSocket() {
  IO.Socket socket = IO.io("http://188.213.64.78:8000/home");

  socket.onConnect((_) {
    print('Connected!');
  });
  socket.on("NewEntry", (data) {
    // This where we should send data in notification
    print(data);
    showAlertInNotif(data);
  });
  socket.onDisconnect((_) => print("Disconnected!"));
}

void showAlertInNotif(data) async {
  var android = AndroidNotificationDetails(
      "channelId", "channelName", "channelDescription",
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  // 2: is title of notif
  // 3: is body of notif
  await localNotif.show(0, "پیام", "نتیجه بررسی وضعیت پارکینگ", platform,
      payload: data['slot_id']);
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
    getCurrentAppLockPassStatus();

    // init and getting instance
    localNotif = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@minmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    // initialize settings on both platforms
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    localNotif.initialize(initSettings,
        onSelectNotification: selectedNotification);
  }

  // Preparing payload for setting msg in case of alert!
  Future selectedNotification(String payload) {
    debugPrint(payload);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: CustomText(
          text: "پیام",
        ),
        content: CustomText(
          text: "$payload",
        ),
      ),
    );
  }

  // Getting app theme dark or light in provider
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  // Getting app Lock state for locking app with OTP Password
  void getCurrentAppLockPassStatus() async {
    themeChangeProvider.appLock =
        await themeChangeProvider.darkThemePreferences.getLockState();
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
            ChangeNotifierProvider<TermsOfServiceModel>(
              create: (_) => TermsOfServiceModel(),
            ),
            ChangeNotifierProvider<AbuseWarningModel>(
              create: (_) => AbuseWarningModel(),
            ),
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
                  initialRoute: splashScreenRoute,
                  routes: {
                    splashScreenRoute: (context) => SplashScreen(),
                    loginRoute: (context) => Login(),
                    forgetPasswordRoute: (context) => ForgetPasswordPage(),
                    otpRoute: (context) => OTPSubmission(),
                    recoverPasswordRoute: (context) => RecoverPassword(),
                    mainoRoute: (context) => Maino(),
                    searchByPlateRoute: (context) => SearchByPlate(),
                    searchBySlotRoute: (context) => SearchingBySlot(),
                    searchByPersCodeRoute: (context) =>
                        SearchingByPersonalCode(),
                    searchByCameraRoute: (context) => SearchingByCamera(),
                    searchResults: (context) => SearchResults(),
                    entryCheck: (context) => EntryCheck(),
                    exitCheck: (context) => ExitCheck(),
                    imgChecker: (context) => ImageChecking(),
                    profile: (context) => Profile(),
                    buildingsRoute: (context) => Buildings(),
                    confirmationRoute: (context) => Confirmation(),
                    bookmarkRoute: (context) => Bookmarked(),
                    imgProcessRoute: (context) => ImgProcessingResult(),
                    settingsRoute: (context) => SettingsView(),
                    editPage: (context) => EditPage(),
                    setAppLock: (context) => SetAppLockOTPView(),
                    savingAppLockPass: (context) => SavingAppLock(),
                    readTermsOfService: (context) => ReadTermsOfService(),
                    // If user enable app local lock show this view and
                    // prevent from entry without passCode
                    localAuthLocker: (context) => LocalAuthEnter(),
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
