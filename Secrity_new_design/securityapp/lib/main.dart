import 'package:flutter/material.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:sizer/sizer.dart';
import 'model/classes/ThemeColor.dart';

// Screens
import 'package:securityapp/view/splashScreen.dart';
import 'package:securityapp/view/login.dart';
import 'package:securityapp/view/maino.dart';
import 'package:securityapp/view/searchingPlate.dart';
import 'package:securityapp/view/searchingSlot.dart';
import 'package:securityapp/view/searchResults.dart';
import 'package:securityapp/view/entryCheck.dart';
import 'package:securityapp/view/introPages/exitCheck.dart';
import 'package:securityapp/view/ImageCheckingTime.dart';
import 'package:securityapp/view/profile.dart';
import 'package:securityapp/view/buildingForUsers.dart';
import 'package:securityapp/view/confirmation.dart';
import 'view/bookmarked.dart';
import 'view/imgProcessResult.dart';
import 'package:securityapp/view/editePage.dart';

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
    getCurrentAppTheme();
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
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  initialRoute: splashScreenRoute,
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
                    editPage: (context) => EditPage(),
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
