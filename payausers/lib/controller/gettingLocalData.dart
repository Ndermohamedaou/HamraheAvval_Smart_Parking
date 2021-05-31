import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class LocalDataGetterClass {
  FlutterSecureStorage lds = FlutterSecureStorage();
  ApiAccess api = ApiAccess();
  Dio dio = Dio();

  Future<Map> getStaffInfoFromLocal() async {
    String readyAvatar = "";
    String readyUserId = "";
    final userId = await lds.read(key: "user_id");
    final localEmail = await lds.read(key: "email");
    final userToken = await lds.read(key: "token");
    final name = await lds.read(key: "name");
    final personalCode = await lds.read(key: "personal_code");
    final localAvatar = await lds.read(key: "avatar");
    String section = await lds.read(key: "section");
    String role = await lds.read(key: "role");
    String lastLogin = await lds.read(key: "lastLogin");

    try {
      Map staffInfo = await api.getStaffInfo(token: userToken);
      // Getting server info to check if they had change
      String serverAvatar = staffInfo['avatar'];
      String serverUserId = staffInfo["user_id"];

      // print(staffInfo);
      // Matching local Avatar with Server side
      // avatar if anythings has change it will update!
      if (localAvatar != serverAvatar) {
        readyAvatar = serverAvatar;

        await lds.write(key: "avatar", value: serverAvatar);
      }
      // If userID for QR-code had change from API
      if (userId != serverUserId) {
        readyUserId = serverUserId;

        await lds.write(key: "user_id", value: serverUserId);
      }
    } catch (e) {
      // print(e);
      // IF users connection had problem, use LocalData
      readyAvatar = await lds.read(key: "avatar");
      readyUserId = await lds.read(key: "user_id");
    }

    return {
      "userId": readyUserId != "" ? readyUserId : userId,
      "name": name,
      "personalCode": personalCode,
      "avatar": readyAvatar != "" ? readyAvatar : localAvatar,
      "email": localEmail,
      "section": section,
      "role": role,
      "lastLogin": lastLogin,
    };
  }

  Future<String> getLocalUserName() async => await lds.read(key: "name");
  Future<String> getLocalUserAvatar() async => await lds.read(key: "avatar");

  // Stream getLocalUserAvatarInReal() async* {
  //   yield* Stream.periodic(Duration(seconds: 20), (_) {
  //     return lds.read(key: "avatar");
  //   });
  // }

  Future<dynamic> getSettingsLocalData() async {
    return {
      "name": await lds.read(key: "name"),
      "avatar": await lds.read(key: "avatar")
    };
  }
}
