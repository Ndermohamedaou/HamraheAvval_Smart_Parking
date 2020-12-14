import 'package:dio/dio.dart';

class ApiAccess {
  // Getting instance of Dio for relation between client and server
  Dio dio = Dio();

  Future<Map> gettingUsersInfo(uToken) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${uToken}";
    // Get User info with Map Type
    Response response = await dio.get("http://10.0.2.2:8000/api/userInfo");
    return response.data;
  }

  Future<bool> updateUserInfo(avatar, uToken, email, pass) async {
    // if user does not choice any avatar for profile
    if (avatar == null) {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer ${uToken}";
      Response response = await dio.post(
          "http://10.0.2.2:8000/api/UpdateInfo?&email=${email}&password=${pass}");
      if (response.data['status'] == "200")
        return true;
      else
        return false;
    } else {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer ${uToken}";
      Response response = await dio.post(
          "http://10.0.2.2:8000/api/UpdateInfo?&email=${email}&password=${pass}",
          data: avatar);
      if (response.data['status'] == "200") {
        return true;
      } else
        return false;
    }
  }
}
