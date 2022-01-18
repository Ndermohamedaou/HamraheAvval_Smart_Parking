import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class ApiAccess {
  // As a constructor getting init value for token.
  // When token will be null or empty string?
  // When user want, login to application, we don't send any header
  // to api.
  ApiAccess(this.token);
  final String token;

  // Define dio framework for getting object.
  Dio dio = Dio();

  // Request handler method for getting proper response from the server.
  Future requestHandler(String route, String method, Map data) async {
    /// Request Handler.
    ///
    /// route: [String] -> Route to be called which endpoint.
    /// method: [String] -> Method to be used which method we will use to send request.
    /// data: [Map] -> Data to be sent allmost to body.
    /// With this method we can send our route and send method as request to API,
    /// also we can send some data if we need to that.

    // Setting up the x509 standard certificate for the request handeling.
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    Response response = await dio.request(
      "$baseUrl$route",
      data: data,
      options: Options(
        method: method,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  }
}
