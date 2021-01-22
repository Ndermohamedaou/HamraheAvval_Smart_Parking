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
}
