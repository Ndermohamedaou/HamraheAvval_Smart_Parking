import 'package:dio/dio.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreamAPI {
  Dio dio = Dio();

  Stream getUserInfoInReal() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    yield* Stream.periodic(Duration(seconds: 30), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      var res = dio.get("$baseUrl/staffInfo");
      // print(res);
      return res;
    }).asyncMap((event) async => (await event).data);
  }

  Stream getUserCanInstantReserveReal() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    yield* Stream.periodic(Duration(seconds: 30), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      return dio.get("$baseUrl/canInstantReserve");
    }).asyncMap((event) async => (await event).data);
  }
}
