import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/classes/SharedClass.dart';

// Routes
import 'constFile/ConstFile.dart';
import 'security_app.dart';
import 'adding_data.dart';
import 'static_insertion.dart';
import 'camera_insertion.dart';
import 'darkmode_page.dart';
import 'login_page.dart';
import 'forget_pass.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // A Notifier for have realtime dark or light way bg color
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  // add some listener for changing bg color as light or dark
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  // Check local storage with preferences class
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: scaffoldBackgroundColor, // navigation color
            statusBarColor: scaffoldBackgroundColor, // status bar color
          ));
          return Center(
            child: MaterialApp(
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              initialRoute: '/LoginPage',
              routes: {
                '/': (context) => InputSecurityApp(),
                '/addDataMethods': (context) => AdddingDataMethods(),
                '/StylePage': (context) => ScreenStyle(),
                '/StaticInsertion': (context) => StaticInsertion(),
                '/CameraInsertion': (context) => CameraInsertion(),
                '/LoginPage': (context) => LoginPage(),
                '/forgetPassword': (context) => ForgetPasswordPage(),
              },
            ),
          );
        },
      ),
    );
  }
}
