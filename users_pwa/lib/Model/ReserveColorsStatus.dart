import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';

class ReserveStatusSpecification {
  Color getReserveStatusColor(status) {
    switch (status) {
      case -6:
        return Colors.grey;
      case -3:
        return Colors.brown;
      case -2:
        return Colors.grey;
      case -1:
        return Colors.red;
      case 0:
        return Colors.yellow[700];
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      default:
        return Colors.white;
    }
  }

  String getReserveStatusString(status) {
    switch (status) {
      case -6:
        return "رزرو ثابت لغو شده";
      case -3:
        return "عدم استفاده از پارکنیگ";
      case -2:
        return cancelReserveStatus;
      case -1:
        return ignoredReserveStatus;
      case 0:
        return inprocessReserveStatus;
      case 1:
        return admitReserveStatus;
      case 2:
        return performTrafficReserveStatus;
      default:
        return "خارج از انتظار";
    }
  }
}
