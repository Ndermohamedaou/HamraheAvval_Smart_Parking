import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:dio/dio.dart';

class ApiAccess {
  Dio dio = Dio();

  Future<Map> getAccessToLogin({email, password}) async {
    Response res =
        await dio.post("$baseUrl/login?email=$email&password=$password");
    return res.data;
  }

  Future<Map> getStaffInfo({token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.get("$baseUrl/staffInfo");
    return response.data;
  }

  Future<String> getUserAvatar({token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.get("$baseUrl/staffInfo");
    return response.data['avatar'];
  }

  Future<List> getUserPlate({token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.get("$baseUrl/getUserPlates");
    return response.data;
  }

  Future<List> getUserTrafficLogs({token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.get("$baseUrl/getUserTraffic");
    return response.data;
  }

  Future<String> addUserPlate({token, lsPlate}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post(
        "$baseUrl/addUserPlate?plate${lsPlate[0]}&plate1=${lsPlate[1]}&plate2=${lsPlate[2]}&plate3=${lsPlate[3]}");
    print(response.data);
    return response.data;
  }

  Future<String> reserveByUser({token, startTime, endTime, plateNo}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post(
        "$baseUrl/Reserve?reserveTimeStart=$startTime&reserveTimeEnd=$endTime&plate=$plateNo");
    return response.data;
  }

  Future<String> updatingUserAvatar({token, uAvatar}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response =
        await dio.post("$baseUrl/UpdateStaffInfo", data: {"avatar": uAvatar});
    return response.data['status'];
  }

  Future<String> changingUserPassword({token, curPass, newPass}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post(
        "$baseUrl/changePassword?current_password=$curPass&new_password=$newPass");
    print("From API CLASS $response.data");
    return response.data;
  }
}
