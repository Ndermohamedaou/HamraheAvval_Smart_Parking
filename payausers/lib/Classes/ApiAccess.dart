import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:dio/dio.dart';

class ApiAccess {
  Dio dio = Dio();

  Future<Map> getAccessToLogin({email, password}) async {
     Response res =
        await dio.post("$baseUrl/login?email=$email&password=$password");
     return res.data;
  }
}
