import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoadingLocalData {
  Future<Map> gettingStaffInfoInLocal() async {
    final lStorage = FlutterSecureStorage();
    String token = await lStorage.read(key: "uToken");
    String fullname = await lStorage.read(key: "fullName");
    // String personalCode = await lStorage.read(key: "personalCode");
    print(token);
    return {"token": token, "fullname": fullname};
  }
}
