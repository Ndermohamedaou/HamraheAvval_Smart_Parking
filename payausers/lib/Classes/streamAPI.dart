import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class StreamAPI {
  FlutterSecureStorage lds = FlutterSecureStorage();
  Dio dio = Dio();

  Stream getUserInfoReal() async* {
    final token = await lds.read(key: "token");
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      return dio.get("$baseUrl/staffInfo");
    }).asyncMap((event) async => (await event).data);
  }

  Stream getUserCanInstantReserveReal() async* {
    final token = await lds.read(key: "token");
    yield* Stream.periodic(Duration(seconds: 30), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      return dio.get("$baseUrl/canInstantReserve");
    }).asyncMap((event) async => (await event).data);
  }
}
