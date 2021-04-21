import 'package:flutter/material.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';
import 'model/classes/ThemeColor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Screens
import 'package:securityapp/view/splashScreen.dart';
import 'package:securityapp/view/login.dart';
import 'package:securityapp/view/maino.dart';
import 'package:securityapp/view/searchingPlate.dart';
import 'package:securityapp/view/searchingSlot.dart';
import 'package:securityapp/view/searchResults.dart';
import 'package:securityapp/view/entryCheck.dart';
import 'package:securityapp/view/exitCheck.dart';
import 'package:securityapp/view/ImageCheckingTime.dart';
import 'package:securityapp/view/profile.dart';
import 'package:securityapp/view/buildingForUsers.dart';
import 'package:securityapp/view/confirmation.dart';
import 'view/bookmarked.dart';
import 'view/imgProcessResult.dart';
import 'package:securityapp/view/editePage.dart';
import 'package:securityapp/view/searchingByPersonalCode.dart';
import 'package:securityapp/view/settingsView.dart';
import 'package:securityapp/view/setAppLock.dart';
import 'package:securityapp/view/savingAppLockPass.dart';
import 'package:securityapp/view/localAuthEnter.dart';

void main() {
  runApp(MyApp());
  connectSocket();
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

    // init and getting instace
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
                  initialRoute: mainoRoute,
                  routes: {
                    splashScreenRoute: (context) => SplashScreen(),
                    loginRoute: (context) => Login(),
                    mainoRoute: (context) => Maino(),
                    searchByPlateRoute: (context) => SearchByPlate(),
                    searchBySlotRoute: (context) => SearchingBySlot(),
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
                    localAuthLocker: (context) => LocalAuthEnter(),
                    searchByPersCodeRoute: (context) =>
                        SearchingByPersonalCode(),
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
