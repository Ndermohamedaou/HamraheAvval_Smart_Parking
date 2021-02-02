// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:payausers/ConstFiles/constText.dart';
// import 'flushbarStatus.dart';
//
// void checkInternetConnection({context}) async {
//   Dio dio = Dio();
//   try {
//     Response res = await dio.get("http://www.google.com/");
//     print("From Checker ${res.data}");
//     if (res.data == null) {}
//   } catch (e) {
//     print("This is $e");
//     showStatusInCaseOfFlush(
//         context: context,
//         title: connectionFailedTitle,
//         msg: connectionFailed,
//         iconColor: Colors.blue,
//         icon: Icons.wifi_off_rounded);
//   }
// }
