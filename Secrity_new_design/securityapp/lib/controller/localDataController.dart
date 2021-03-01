import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoadingLocalData {
  Future<Map> gettingStaffInfoInLocal() async {
    final lStorage = FlutterSecureStorage();
    String token = await lStorage.read(key: "uToken");
    String fullname = await lStorage.read(key: "fullName");
    String avatar = await lStorage.read(key: "avatar");
    String email = await lStorage.read(key: "email");
    String naturalCode = await lStorage.read(key: "naturalCode");
    String personalCode = await lStorage.read(key: "personalCode");
    String buildingNameFA = await lStorage.read(key: "buildingNameFA");
    String buildingName = await lStorage.read(key: "buildingName");
    return {
      "token": token,
      "fullname": fullname,
      "avatar": avatar,
      "email": email,
      "naturalCode": naturalCode,
      "personalCode": personalCode,
      "buildingNameFA": buildingNameFA,
      "buildingName": buildingName,
    };
  }
}
