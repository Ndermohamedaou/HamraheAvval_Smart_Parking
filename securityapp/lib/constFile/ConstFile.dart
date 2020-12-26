import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const String mainFontFamily = 'BYekan';

// Login Style Material
HexColor sMBColor = HexColor('#172438');
HexColor statusBar = HexColor('#172438');
const String loginTextFontFamily = mainFontFamily;
const double loginTextSize = 22;
const double widthOfLoginLogo = 180;

// API Section
// API URL
// This is not permanently, inorder to be localhost!
// "http://10.0.2.2:8000/api";
// Check const file for API url if you want to change that
// but if you want work with localhost we must use 10.0.2.2 IP address
// because AVD use this ip address as local IP!
// BaseUrl is abstraction of our url api
// Avd local host
const portNum = "8000";
const String avdLocalHost = "http://10.0.2.2:$portNum";
// Physical Device
const String physicalLocalHost = "http://192.168.1.5:$portNum";
// iOS Simulator
const String iosLocalHost = "http://127.0.0.1:$portNum";

const String apiUrl = "$physicalLocalHost/api";

// Main Color for back and scaffold
HexColor backgroundColor = HexColor('#172438');
HexColor scaffoldBackgroundColor = HexColor('#172438');
HexColor accentColor = HexColor('#03c1e5');
// Const of Card in HomeScreen
const double cardStyleMargin = 10;
const cardStyleBorderRadius = 15.0;
const double fontTitleSize = 24;
const String titleFontFamily = mainFontFamily;
var appBarBackgroundColor = HexColor('#1a2e48');
HexColor cardStyleColorDark = HexColor('#1a2e48');
HexColor cardStyleColorLight = HexColor('#f9f9f9');

// Main security app :
const double mainSecurityAppIconSize = 60;
const String mainSecurityAppFontFamily = mainFontFamily;
const double fontSizeDesc = 15;
const double fontSizeTitle = 18;
const Color mainIconColor = Colors.blue;
const Color textTitleColor = Colors.white;
const Color textDescColor = Colors.white70;
//Dialog button FontSize
const double fontSizeDialogButton = 22;

// Data insertion options vars :
const double titleFontSize = 20;
const double subTitleFontSize = 14;
const IconData opt1Icon = Icons.keyboard;
const IconData opt2Icon = CupertinoIcons.photo_camera_solid;
const Color bothIconNativeColor = Colors.black;

// Searching Plate Options and icons and Colors and ets...
// opt1
const IconData slotIcon = CupertinoIcons.square_stack_3d_up;
HexColor slotBgColorIcon = HexColor("#460EBB");
const Color iconColor = Colors.white;

// opt2
const IconData slotStatus = CupertinoIcons.app_fill;
HexColor slotBgColorIconStatus = HexColor('#9EA7C2');

// opt3
const IconData entrySlotIcon = CupertinoIcons.time;
HexColor entryIconColor = HexColor('#4E4F84');
Color entryBgColor = HexColor('#4E4F84');
const Color iconColorEntry = Colors.white;
// opt4
const IconData exitIcon = CupertinoIcons.time_solid;
HexColor exitBgColorIcon = HexColor('#BEB3D1');

HexColor backPanelColor = HexColor('#1a2e48');
