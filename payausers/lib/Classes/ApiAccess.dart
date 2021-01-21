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
}
