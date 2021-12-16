import 'package:shared_preferences/shared_preferences.dart';

class SavingData {
  // Saving data in local storage
  Future<bool> LDS({
    token,
    user_id,
    name,
    email,
    role,
    personal_code,
    melli_code,
    avatar,
    section,
    lastLogin,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> staffInfo = {
      "token": token,
      "user_id": user_id,
      "name": name,
      "email": email,
      "role": role,
      "personal_code": personal_code,
      "melli_code": melli_code,
      "avatar": avatar,
      "section": section,
      "lastLogin": lastLogin,
    };
    staffInfo.forEach((key, value) async {
      await prefs.setString(key, value);
    });
    String uToken = prefs.getString("token");
    return uToken != null ? true : false;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("token");
  }
}
