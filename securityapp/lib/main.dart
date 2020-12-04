import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// Routes
import 'security_app.dart';
import 'adding_data.dart';
import 'static_insertion.dart';
import 'camera_insertion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        backgroundColor: HexColor('#172438'),
        scaffoldBackgroundColor: HexColor('#172438'),
        accentColor: HexColor('#03c1e5'),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => InputSecurityApp(),
        '/addDataMethods': (context) => AdddingDataMethods(),
        '/StaticInsertion': (context) => StaticInsertion(),
        '/CameraInsertion': (context) => CameraInsertion(),
      },
    );
  }
}
