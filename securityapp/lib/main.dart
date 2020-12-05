import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/classes/SharedClass.dart';


// Routes
import 'security_app.dart';
import 'adding_data.dart';
import 'static_insertion.dart';
import 'camera_insertion.dart';
import 'darkmode_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentAppTheme();
  }

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
          return MaterialApp(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            initialRoute: '/',
            routes: {
              '/': (context) => InputSecurityApp(),
              '/addDataMethods': (context) => AdddingDataMethods(),
              '/StylePage': (context) => ScreenStyle(),
              '/StaticInsertion': (context) => StaticInsertion(),
              '/CameraInsertion': (context) => CameraInsertion(),
            },
          );
        },
      ),
    );
  }
}
