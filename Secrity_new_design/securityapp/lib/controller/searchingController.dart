import 'package:securityapp/model/ApiAccess.dart';

import 'localDataController.dart';

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
    LoadingLocalData llds = LoadingLocalData();

    Map loadLocalData = await llds.gettingStaffInfoInLocal();
    String buildingName = loadLocalData["buildingName"];

    try {
      return await api.searchingBySlot(
          uToken: token, slotNum: slot, buildingName: buildingName);
    } catch (e) {
      print("Error from searching by slot: $e");
      return {};
    }
  }

  Future<Map> searchingByPersonalCode({token, persCode}) async {
    try {
      return await api.searchingByPersonalCode(
          uToken: token, persCode: persCode);
    } catch (e) {
      print("Error from searching by Personal Code: $e");
      return {};
    }
  }

  Future<Map> searchingByCapturedImage({token, capturedImage}) async {
    try {
      return await api.searchingByImage(uToken: token, img: capturedImage);
    } catch (e) {
      print("Error from searching by Captured Image: $e");
      return {};
    }
  }
}
