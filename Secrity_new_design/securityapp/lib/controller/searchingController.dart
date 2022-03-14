import 'package:securityapp/model/ApiAccess.dart';

import 'localDataController.dart';

class SearchingCar {
  // TODO: Change this class
  ApiAccess api = ApiAccess();
  Future<dynamic> searchingByPlate({token, List plates, building}) async {
    return await api.searchingByPlate(
      uToken: token,
      plates: plates,
      buildingName: building,
    );
  }

  Future<dynamic> searchingBySlot({token, slot}) async {
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

  Future<dynamic> searchingByPersonalCode({token, persCode, building}) async {
    try {
      return await api.searchingByPersonalCode(
          uToken: token, persCode: persCode, buildingName: building);
    } catch (e) {
      print("Error from searching by Personal Code: $e");
      return {};
    }
  }

  Future<dynamic> searchingByCapturedImage(
      {token, capturedImage, building}) async {
    try {
      return await api.searchingByImage(
        uToken: token,
        img: capturedImage,
        buildingName: building,
      );
    } catch (e) {
      print("Error from searching by Captured Image: $e");
      return {};
    }
  }
}
