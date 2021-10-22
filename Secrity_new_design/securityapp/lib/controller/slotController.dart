import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:securityapp/model/ApiAccess.dart';

class SlotsViewer {
  final lStorage = FlutterSecureStorage();

  ApiAccess api = ApiAccess();
  Future<Map> gettingSlots() async {
    String token = await lStorage.read(key: "uToken");
    // print(token);
    String buildingName = await lStorage.read(key: "buildingName");
    // print(buildingName);

    try {
      return await api.getSlots(
        uAuth: token,
        slotName: buildingName,
      );
    } catch (e) {
      print("Error from slots controller $e");
      return {};
    }
  }
}
