// import 'dart:html';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:payausers/Classes/ThemeColor.dart';
// import 'package:payausers/ConstFiles/constText.dart';
// import 'package:payausers/ConstFiles/initialConst.dart';
// import 'package:provider/provider.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';

// class LogoutBtn extends StatelessWidget {
//   const LogoutBtn();

//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     void runAlert() {
//       Alert(
//         context: context,
//         type: AlertType.warning,
//         title: "خروج از حساب",
//         desc:
//             "اگر قصد خارج شدن از حساب خود را دارید بر روی دکمه بلی کلیک کنید و از برنامه خارج خواهید شد",
//         style: AlertStyle(
//             backgroundColor: themeChange.darkTheme ? darkBar : Colors.white,
//             titleStyle: TextStyle(
//               fontFamily: mainFaFontFamily,
//             ),
//             descStyle: TextStyle(fontFamily: mainFaFontFamily)),
//         buttons: [
//           DialogButton(
//             color: Colors.red,
//             child: Text(
//               submitTextForAlert,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontFamily: mainFaFontFamily),
//             ),
//             onPressed: () async {
//               // SharedPreferences prefs = await SharedPreferences.getInstance();

//               // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//               // await prefs.clear();
//               // Toast.show("مجددا به حساب خود وارد شوید", context,
//               //     duration: Toast.LENGTH_LONG,
//               //     gravity: Toast.BOTTOM,
//               //     textColor: Colors.white);
//               // Navigator.pushNamed(context, '/splashScreen');
//               // window.close();
//               print("Coic");
//             },
//             width: 120,
//           ),
//           DialogButton(
//             // color: Colors.red,
//             child: Text(
//               "لغو",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontFamily: mainFaFontFamily),
//             ),
//             onPressed: () => Navigator.pop(context),
//             width: 120,
//           )
//         ],
//       ).show();
//     }

//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       child: FlatButton(
//         onPressed: () => runAlert(),
//         child: Text(
//           logoutBtnText,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               color: Colors.red.shade800,
//               fontFamily: mainFaFontFamily,
//               fontSize: 18,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
