import 'package:flutter/material.dart';
import 'package:payausers/localization/app_localization.dart';

class ReserveStatusSpecification {
  final context;
  ReserveStatusSpecification(this.context);
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
    AppLocalizations t = AppLocalizations.of(context);

    switch (status) {
      case -6:
        return t.translate("reserves.reserveStatus.cancelStaticReserve");
      case -3:
        return t.translate("reserves.reserveStatus.parkingNotUsed");
      case -2:
        return t.translate("reserve.reserveStatus.canceledReserve");
      case -1:
        return t.translate("reserve.reserveStatus.ignoredReserveStatus");
      case 0:
        return t.translate("reserve.reserveStatus.process");
      case 1:
        return t.translate("reserve.reserveStatus.admitReserveStatus");
      case 2:
        return t.translate("reserve.reserveStatus.performTrafficReserveStatus");
      default:
        return t.translate("global.default.unknown");
    }
  }
}
