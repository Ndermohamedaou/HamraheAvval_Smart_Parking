import 'package:flutter/material.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:provider/provider.dart';

// Screens
import 'Screens/intro.dart';
import 'Screens/loginPage.dart';

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
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => IntroPage(),
              '/login': (context) => LoginPage(),
            },
          );
        },
      ),
    );
  }
}
