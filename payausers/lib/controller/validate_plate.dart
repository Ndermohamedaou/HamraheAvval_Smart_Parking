import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/localization/app_localization.dart';

class ValidatePlate {
  ///
  /// This class made for validate both number and system exist.
  /// Will have one method to do this mission.
  final context;
  ValidatePlate(this.context);

  Future<Map> isPlateValid(String plate0, String plate1, String plate2,
      String plate3, String token) async {
    /// Checking plate number is valid or not.
    ///
    /// What is meaning of valid?
    /// when we say this plate was plate, it would complete plate number
    /// by this pattern: 2 1 3 2.
    /// and when this plate doesn't exist in db, it will return null.
    AppLocalizations t = AppLocalizations.of(context);
    ApiAccess api = ApiAccess(token);
    bool plateNumberOk =
        plate0.length == 2 && plate2.length == 3 && plate3.length == 2;
    Endpoint plateExistenceEndpoint =
        apiEndpointsMap["plateEndpoint"]["checkPlateExistence"];

    // Create plate structure.
    PlateStructure plate = PlateStructure(plate0, plate1, plate2, plate3);

    // Send plate as request in query parameter.
    final checkedPlate = await api.requestHandler(
        "${plateExistenceEndpoint.route}?plate0=${plate.plate0}&plate1=${plate.plate1}&plate2=${plate.plate2}&plate3=${plate.plate3}",
        plateExistenceEndpoint.method, {});

    // Create proper message to users.
    Map message = {
      "plateNumber": plateNumberOk,
      "plateExist": checkedPlate["status"] == "200" ? true : false,
      "title": !plateNumberOk
          ? t.translate("plates.addPlate.addPlateErrorTitle")
          : checkedPlate["status"] == "409"
              ? t.translate("plates.addPlate.addPlateErrorTitle")
              : "",
      "desc": !plateNumberOk
          ? t.translate("plates.addPlate.addPlateErrorDesc")
          : checkedPlate["status"] == "409"
              ? t.translate("plates.addPlate.addPlateErrorDesc")
              : "",
    };

    return message;
  }
}
