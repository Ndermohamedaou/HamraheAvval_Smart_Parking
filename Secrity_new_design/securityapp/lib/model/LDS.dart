import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SavingData {
// LStorage
  final lStorage = FlutterSecureStorage();

  // Saving data in local storage
  Future<bool> LDS(
      {token,
      user_id,
      name,
      email,
      role,
      personal_code,
      melli_code,
      avatar,
      section}) async {
    Map<String, dynamic> staffInfo = {
      "token": token,
      "user_id": user_id,
      "name": name,
      "email": email,
      "role": role,
      "personal_code": personal_code,
      "melli_code": melli_code,
      "avatar": avatar,
      "section": section
    };
    staffInfo.forEach((key, value) async {
      await lStorage.write(key: key, value: value);
    });
    String uToken = await lStorage.read(key: "token");
    return uToken != null ? true : false;
  }

  // Future<bool> savingPlate({plates}) async {
  //   int plateIndexer = 0;
  //   plates.forEacht((plate) async {
  //     dynamic plateQty = [
  //       plate["plate0"],
  //       plate["plate1"],
  //       plate["plate2"],
  //       plate["plate3"]
  //     ];
  //     await lStorage.write(key: "plate${plateIndexer}", value: plateQty);
  //     plateIndexer += 1;
  //   });
  //   List plateTest = await lStorage.read(key: "plate0") as List;
  //   print(plateTest);
  //   return plateTest != [] ? true : false;
  // }

  Future<String> getToken() {
    return lStorage.read(key: "token");
  }
}
