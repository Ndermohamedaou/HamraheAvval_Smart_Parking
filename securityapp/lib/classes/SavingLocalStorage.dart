import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalizationDataStorage {
  // Local Storage Super Secure!
  final lStorage = FlutterSecureStorage();

  // Saving ls data function
  Future<bool> savingUInfo(
      {uToken,
      email,
      password,
      avatar,
      fullName,
      naturalCode,
      personalCode,
      buildingName,
      buildingNameFA}) async {
    Map<String, dynamic> usersInfo = {
      "uToken": uToken,
      "email": email,
      "password": password,
      "avatar": avatar,
      "fullName": fullName,
      "naturalCode": naturalCode,
      "personalCode": personalCode,
      "buildingName": buildingName,
      "buildingNameFA": buildingNameFA
    };
    usersInfo.forEach((key, value) async {
      await lStorage.write(key: key, value: value);
    });
    String userToken = await lStorage.read(key: "uToken");
    if (userToken != "") {
      return true;
    } else
      return false;
  }

  Future<String> gettingUserToken() async {
    return await lStorage.read(key: "uToken");
  }

  Future<String> gettingUserSlot() async {
    return await lStorage.read(key: "buildingName");
  }

  // For logout and deleting all local information
  void deleteUuToken() async {
    lStorage.deleteAll();
  }
}
