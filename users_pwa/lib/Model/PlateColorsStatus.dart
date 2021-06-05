import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';

class PlateStatusSpecification {
  Color getPlateStatusColor(status) {
    switch (status) {
      case -1:
        return Colors.red;
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
        break;
      default:
        return Colors.blue;
    }
  }

  String getPlateStatusString(status) {
    switch (status) {
      case -1:
        return ignoredPlateText;
      case 0:
        return deniedPlateText;
      case 1:
        return acceptedPlateText;
        break;
      default:
        return "خارج از انتظار";
    }
  }
}
