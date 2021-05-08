import 'package:payausers/Classes/ApiAccess.dart';

ApiAccess api = ApiAccess();

class AddPlateProc {
  // Self
  Future<int> minePlateReq({token, List plate, selfMelli, selfCarCard}) async {
    print(token);
    try {
      final result = await api.addSelfPlate(
          token: token,
          lsPlate: plate,
          selfMelliCard: selfMelli,
          selfCarCard: selfCarCard);

      if (result == "200") {
        return 200;
      }

      if (result == "MaxPlateCount") {
        return 100;
      }

      if (result == "PlateExists") {
        return 1;
      }
    } catch (e) {
      print("Erorr from addingaddUserPlat mine plate $e");
      return -1;
    }
  }

  // Family
  Future<int> familyPlateReq(
      {token, List plate, selfMelli, ownerMelli, ownerCarCard}) async {
    try {
      final result = await api.addFamilyPlate(
          token: token,
          lsPlate: plate,
          selfMelliCard: selfMelli,
          ownerMelliCard: ownerMelli,
          ownerCarCard: ownerCarCard);
      if (result == "200") {
        return 200;
      }

      if (result == "MaxPlateCount") {
        return 100;
      }

      if (result == "PlateExists") {
        return 1;
      }
    } catch (e) {
      print("Erorr from addingaddUserPlat mine plate $e");
      return -1;
    }
  }

  // Other
  Future<int> otherPlateReq({token, List plate}) async {
    try {
      final result = await api.addOtherPlate(token: token, lsPlate: plate);
      if (result == "InPersonVisit") {
        return 200;
      }

      if (result == "MaxPlateCount") {
        return 100;
      }

      if (result == "PlateExists") {
        return 1;
      }
    } catch (e) {
      print("Erorr from addingaddUserPlat mine plate $e");
      return -1;
    }
  }
}
