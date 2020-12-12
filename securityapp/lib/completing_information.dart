// import 'package:flutter/material.dart';
//
// /*

//
//
//
// import 'package:flutter/animation.dart';
// import 'package:flutter/material.dart';
// import 'constFile/ConstFile.dart';
// import 'constFile/texts.dart';
// import 'extractsWidget/login_extract_text_fields.dart';
// import 'package:dio/dio.dart';
// import 'package:toast/toast.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// // Index of page for forward ahead with btn
// int pageIndex = 0;
// // On Break
// bool breadConfirm = false;
// // Define Main var global
// // in this files and separate with other vars
// String userEmail = "";
// String userPassword = "";
// String userConfirmPassword = "";
// bool protectedPassword = true;
// Map<String, Object> uToken;
// // some validation in text fields
// IconData showMePass = Icons.remove_red_eye;
// dynamic emptyTextFieldErrEmail = null;
// dynamic emptyTextFieldErrPass = null;
// dynamic emptyTextFieldErrConfirmPass = null;
//
// // Creating PageController for forwarding ahead with btn
// // without use swapping finger on screen
// PageController _pageController = PageController();
//
// class ConfirmationPage extends StatefulWidget {
//   @override
//   _ConfirmationPageState createState() => _ConfirmationPageState();
// }
//
// class _ConfirmationPageState extends State<ConfirmationPage> {
//   Dio dio = Dio();
//
  // To sending confirm information
  // void confirmationProcessing(email, pass, confirmPass) async {
  //   // print("==========${uToken['userToken']}==========");
  //   if (email != "" || pass != "" || confirmPass != "") {
  //     if (pass == confirmPass) {
  //       if (pass.length > 6 && confirmPass.length > 6) {
  //         try {
  //           dio.options.headers['content-type'] = 'application/json';
  //           dio.options.headers['authorization'] =
  //               "Bearer ${uToken['userToken']}";
  //           Response response =
  //               await dio.get("http://10.0.2.2:8000/api/userInfo/");
  //           // show case
  //           print(response);
  //           // TODO
  //           // what does parameters will go to local storage? (with response List)
  //           // Token as String
  //           // await lStorage.write(key: "uToken", value: uToken);
  //           // fullName as String
  //           // email as String
  //
  //         } catch (e) {
  //           print(e);
  //         }
  //       }
  //     } else {
  //       Toast.show(notMatch, context,
  //           duration: Toast.LENGTH_LONG,
  //           gravity: Toast.BOTTOM,
  //           textColor: Colors.white);
  //     }
  //   } else {
  //     setState(() {
  //       emptyTextFieldErrEmail = emptyTextFieldMsg;
  //       emptyTextFieldErrPass = emptyTextFieldMsg;
  //       emptyTextFieldErrConfirmPass = emptyTextFieldMsg;
  //     });
  //   }
  // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Material(
//           elevation: 10.0,
//           borderRadius: BorderRadius.circular(8.0),
//           color: Colors.blue[900],
//           child: MaterialButton(
//             padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//             onPressed: () {
//               // confirmationProcessing(
//               //     userEmail, userPassword, userConfirmPassword);
//
//               _pageController.animateTo(MediaQuery.of(context).size.width,
//                   duration: new Duration(milliseconds: 500), curve: Curves.easeIn);
//             },
//             child: Text(
//               confirmText,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: loginTextFontFamily,
//                   fontSize: loginTextSize,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//       body: _ConfirmationPage(),
//     );
//   }
// }
//
// class _ConfirmationPage extends StatefulWidget {
//   @override
//   __ConfirmationPageState createState() => __ConfirmationPageState();
// }
//
// class __ConfirmationPageState extends State<_ConfirmationPage> {
//   // Getting token from main login page as new arg in here
//
//   @override
//   Widget build(BuildContext context) {
//     uToken = ModalRoute.of(context).settings.arguments;
//
//     return SafeArea(
//       child: PageView(
//         onPageChanged: (viewIndex) {
//           setState(() {
//             pageIndex = viewIndex;
//             print(pageIndex);
//           });
//         },
//         controller: _pageController,
//         physics: NeverScrollableScrollPhysics(),
//         children: [
//           Container(
//               child: Column(
//
//               )
//           ),
//           Container(
//             child: Text("Email with confirm password"),
//           ),
//         ],
//       ),
//     );
//   }
// }
