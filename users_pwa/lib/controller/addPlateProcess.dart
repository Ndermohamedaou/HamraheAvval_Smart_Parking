import 'package:payausers/Classes/ApiAccess.dart';

ApiAccess api = ApiAccess();

class AddPlateProc {
  // Self
  Future<bool> minePlateReq({token, List plate, selfMelli, selfCarCard}) async {
    print(token);
    try {
      await api.addSelfPlate(
          token: token,
          lsPlate: plate,
          selfMelliCard: selfMelli,
          selfCarCard: selfCarCard);
      return true;
    } catch (e) {
      print("Erorr from addingaddUserPlat mine plate $e");
      return false;
    }
  }

  // Family
  Future<bool> familyPlateReq(
      {token, List plate, selfMelli, ownerMelli, ownerCarCard}) async {
    try {
      await api.addFamilyPlate(
          token: token,
          lsPlate: plate,
          selfMelliCard: selfMelli,
          ownerMelliCard: ownerMelli,
          ownerCarCard: ownerCarCard);
      return true;
    } catch (e) {
      print("Erorr from adding mine plate $e");
      return false;
    }
  }

  // Other
  Future<bool> otherPlateReq({token, List plate}) async {
    try {
      await api.addOtherPlate(token: token, lsPlate: plate);
      return true;
    } catch (e) {
      print("Erorr from adding mine plate $e");
      return false;
    }
  }
}
