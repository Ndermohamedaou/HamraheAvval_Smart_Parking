import 'package:dio/dio.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataGetterClass {
  Dio dio = Dio();

  Future<Map> getStaffInfoFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String readyAvatar = "";
    String readyUserId = "";
    final userId = prefs.getString("user_id");
    final localEmail = prefs.getString("email");
    final userToken = prefs.getString("token");
    final name = prefs.getString("name");
    final personalCode = prefs.getString("personal_code");
    final localAvatar = prefs.getString("avatar");
    String section = prefs.getString("section");
    String role = prefs.getString("role");
    String lastLogin = prefs.getString("lastLogin");

    ApiAccess api = ApiAccess(userToken);
    try {
      Endpoint staffInfoEndpoint = apiEndpointsMap["auth"]["staffInfo"];
      final staffInfo = await api.requestHandler(
          staffInfoEndpoint.route, staffInfoEndpoint.method, {});

      // Getting server info to check if they had change
      String serverAvatar = staffInfo['avatar'];
      String serverUserId = staffInfo["user_id"];

      // print(staffInfo);
      // Matching local Avatar with Server side
      // avatar if anythings has change it will update!
      if (localAvatar != serverAvatar) {
        readyAvatar = serverAvatar;

        prefs.setString("avatar", serverAvatar);
      }
      // If userID for QR-code had change from API
      if (userId != serverUserId) {
        readyUserId = serverUserId;

        prefs.setString("user_id", serverUserId);
      }
    } catch (e) {
      // print(e);
      // IF users connection had problem, use LocalData
      readyAvatar = prefs.getString("avatar");
      readyUserId = prefs.getString("user_id");
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
}
