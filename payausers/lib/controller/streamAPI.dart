import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class StreamAPI {
  FlutterSecureStorage lds = FlutterSecureStorage();
  Dio dio = Dio();

  // Will use in Dashboard traffic log length
  // Will use in User Traffics tab
  Stream getUserTrafficsReal() async* {
    final token = await lds.read(key: "token");
    yield* Stream.periodic(Duration(minutes: 10), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      return dio.get("$baseUrl/getUserTraffic");
      // print(response.data);
    }).asyncMap((event) async => (await event).data);
  }

  // Will use in Dashboard for showing length of user traffices
  // Wiil use in Reserve Tab
  Stream getUserReserveReal() async* {
    final token = await lds.read(key: "token");
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      return dio.get("$baseUrl/getUserReserves");
    }).asyncMap((event) async => (await event).data);
  }

  // Will use in Dashboard for showing length of user plates
  // Will use in User Plates tab
  Stream getUserPlatesReal() async* {
    final token = await lds.read(key: "token");
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      return dio.get("$baseUrl/getUserPlates");
    }).asyncMap((event) async => (await event).data);
  }

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
    yield* Stream.periodic(Duration(seconds: 10), (_) {
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $token";
      return dio.get("$baseUrl/canInstantReserve");
    }).asyncMap((event) async => (await event).data);
  }
}
