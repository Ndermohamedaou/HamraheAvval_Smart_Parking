import 'package:payausers/Classes/ApiAccess.dart';

ApiAccess api = ApiAccess();

class AddPlateProc {
  Future<bool> minePlateReq({token, List plate, ncMinCard}) async {
    try {
      // TODO: Connect this where to API
      return true;
    } catch (e) {
      print("Erorr from adding mine plate $e");
      return false;
    }
  }

  Future<bool> familyPlateReq(
      {token, List plate, ncMineCard, ncFamilyCard, carFamilyCar}) async {
    try {} catch (e) {
      print("Erorr from adding mine plate $e");
    }
  }

  Future<bool> otherPlateReq({token, List plate}) async {
    try {} catch (e) {
      print("Erorr from adding mine plate $e");
    }
  }
}
