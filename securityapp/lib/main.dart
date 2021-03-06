import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'classes/SharedClass.dart';

// Routes
import 'constFile/ConstFile.dart';
import 'security_app.dart';
import 'adding_data.dart';
import 'carExitComplete.dart';
import 'camera_insertion.dart';
import 'login_page.dart';
import 'confirmation_page.dart';
import 'forget_pass.dart';
import 'splash_screen.dart';
import 'search_plate_section.dart';
import 'carDetailsPage.dart';
import 'camera_grid.dart';
import 'slots_view.dart';
import 'set_building.dart';
import 'edit_profile.dart';
import 'profile_details.dart';

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
            systemNavigationBarColor: scaffoldBackgroundColor,
            // navigation color
            statusBarColor: scaffoldBackgroundColor, // status bar color
          ));
          return Center(
            child: MaterialApp(
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              initialRoute: '/',
              routes: {
                '/': (context) => SplashScreen(),
                '/main': (context) => InputSecurityApp(),
                '/addDataMethods': (context) => AdddingDataMethods(),
                '/StaticInsertion': (context) => StaticInsertion(),
                '/CameraInsertion': (context) => CameraInsertion(),
                '/LoginPage': (context) => LoginPage(),
                '/confirmation': (context) => ConfirmationPage(),
                '/forgetPassword': (context) => ForgetPasswordPage(),
                '/plateSearch': (context) => SearchPlateSection(),
                '/carDetails': (context) => CarDetails(),
                '/setBuilding': (context) => SetBuilding(),
                '/editProfile': (context) => EditProfile(),
                '/profile_details': (context) => ProfileDetails(),
              },
            ),
          );
        },
      ),
    );
  }
}
