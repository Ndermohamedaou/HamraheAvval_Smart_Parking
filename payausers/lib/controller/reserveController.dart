import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/controller/alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import '../ConstFiles/constText.dart';

// void reserveMe({st, et, context}) async {
//   // if (st != "" && et != "" && pt != "") {
//   if (st != "" && et != "") {
//     ApiAccess api = ApiAccess();
//     FlutterSecureStorage lds = FlutterSecureStorage();
//     final userToken = await lds.read(key: "token");
//     try {
//       String reserveResult =
//           await api.reserveByUser(token: userToken, startTime: st, endTime: et);
//       // print("$reserveResult");
//       if (reserveResult == "200") {
//         rAlert(
//             context: context,
//             onTapped: () =>
//                 Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
//             tAlert: AlertType.success,
//             title: titleOfReserve,
//             desc: resultOfReserve);
//       } else if (reserveResult == "AlreadyReserved") {
//         rAlert(
//             context: context,
//             onTapped: () =>
//                 Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
//             tAlert: AlertType.warning,
//             title: titleOfFailedReserve,
//             desc: descOfFailedReserve);
//       }
//     } catch (e) {
//       Toast.show(serverConnectionProblem, context,
//           duration: Toast.LENGTH_LONG,
//           gravity: Toast.BOTTOM,
//           textColor: Colors.white);
//     }
//   } else
//     Toast.show(dataEntryInCorrect, context,
//         duration: Toast.LENGTH_LONG,
//         gravity: Toast.BOTTOM,
//         textColor: Colors.white);
// }
