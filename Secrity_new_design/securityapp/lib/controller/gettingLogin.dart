import 'package:securityapp/model/ApiAccess.dart';

class AuthUsers {
  ApiAccess api = ApiAccess();

  Future<Map<String, dynamic>> gettingLogin({persCode, pass}) async {
    try {
      return await api.login(personalCode: persCode, password: pass);
    } catch (e) {
      print("Error from login controller $e");
      return {"status": "null"};
    }
  }

  Future<List> gettingbuildings(token) async {
    try {
      return await api.getBuilding(token);
    } catch (e) {
      print("Error from getting buildings controller $e");
      return [];
    }
  }

  Future<Map> gettingStaffInfo(token) async {
    try {
      return await api.gettingUsersInfo(token);
    } catch (e) {
      print("Error from getting Staff Info controller $e");
      return {};
    }
  }

  Future<bool> updateStaffInfo({avatar, pass, token}) async {
    try {
      bool result = await api.updateUserInfo(
        avatar: avatar,
        pass: pass,
        uToken: token,
      );
      return result;
    } catch (e) {
      print("Error from Updating Staff Info controller $e");
      return false;
    }
  }

  Future<bool> updateStaffAvatar({token, avatar}) async {
    try {
      return await api.updateAvatar(uAvatar: avatar, uToken: token);
    } catch (e) {
      return false;
    }
  }
}
