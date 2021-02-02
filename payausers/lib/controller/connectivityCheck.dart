import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'flushbarStatus.dart';

void checkInternetConnection({context}) async {
  Dio dio = Dio();
  try {
    await dio
        .get("http://tms6.tvu.ac.ir:7001/Student/Pages/acmstd/loginPage.jsp");
  } catch (e) {
    showStatusInCaseOfFlush(
        context: context,
        title: connectionFailedTitle,
        msg: connectionFailed,
        iconColor: Colors.blue,
        icon: Icons.wifi_off_rounded);
  }
}
