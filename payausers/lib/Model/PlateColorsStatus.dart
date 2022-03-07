import 'package:flutter/material.dart';
import 'package:payausers/localization/app_localization.dart';

class PlateStatusSpecification {
  final context;
  PlateStatusSpecification(this.context);

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
    AppLocalizations t = AppLocalizations.of(context);
    switch (status) {
      case -1:
        return t.translate("global.info.ignoredPlateText");
      case 0:
        return t.translate("global.info.deniedPlateText");
      case 1:
        return t.translate("global.info.acceptedPlateText");
        break;
      default:
        return t.translate("global.default.unknown");
    }
  }
}
