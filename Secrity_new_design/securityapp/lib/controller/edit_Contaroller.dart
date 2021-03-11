import 'package:securityapp/model/ApiAccess.dart';
import 'package:securityapp/view/confirmation.dart';

class EditStaffInfo {
  ApiAccess api = ApiAccess();

  Future<bool> changeEmail({token, String email}) async {
    try {
      return await api.updateUserInfo(uToken: token, email: email);
    } catch (e) {
      print("Error in change emaill $e");
      return false;
    }
  }

  Future<bool> changePassword({token, pass}) async {
    try {
      return await api.updateUserInfo(uToken: token, pass: password);
    } catch (e) {
      print("Error in change password $e");
      return false;
    }
  }
}
