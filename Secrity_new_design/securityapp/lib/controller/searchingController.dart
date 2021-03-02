import 'package:securityapp/model/ApiAccess.dart';

class SearchingCar {
  ApiAccess api = ApiAccess();
  Future<List> searchingByPlate({token, List plates}) async {
    try {
      return await api.searchingByPlate(uToken: token, plates: plates);
    } catch (e) {
      print("Error from searching by plate : $e");
      return [];
    }
  }

  Future<Map> searchingBySlot({token, slot}) async {
    try {
      return await api.searchingBySlot(uToken: token, slotNum: slot);
    } catch (e) {
      print("Error from searching by slot: $e");
      return {};
    }
  }
}
