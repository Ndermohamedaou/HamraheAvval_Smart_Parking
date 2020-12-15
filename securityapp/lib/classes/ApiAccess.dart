import 'package:dio/dio.dart';
import 'package:securityapp/constFile/ConstFile.dart';

class ApiAccess {
  // Getting instance of Dio for relation between client and server
  Dio dio = Dio();

  Future<Map> gettingUsersInfo(uToken) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${uToken}";
    // Get User info with Map Type
    Response response = await dio.get("${apiUrl}/userInfo");
    return response.data;
  }

  Future<bool> updateUserInfo(avatar, uToken, email, pass) async {
    // if user does not choice any avatar for profile
    if (avatar == null) {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer ${uToken}";
      Response response = await dio
          .post("${apiUrl}/UpdateInfo?&email=${email}&password=${pass}");
      if (response.data['status'] == "200")
        return true;
      else
        return false;
    } else {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer ${uToken}";
      Response response = await dio.post(
          "${apiUrl}/UpdateInfo?&email=${email}&password=${pass}",
          data: avatar);
      if (response.data['status'] == "200") {
        return true;
      } else
        return false;
    }
  }
}
