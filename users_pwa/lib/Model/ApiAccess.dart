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
  // Setting connectTimeout and receiveTimeout for fault error handling.
  Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: 60 * 1000,
    receiveTimeout: 60 * 1000,
  ));

  /*
  "Access-Control-Allow-Origin": "*", // Required for CORS support to work
  "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
  "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "Access-Control-Allow-Methods": "POST, OPTIONS"
   */

  // Request handler method for getting proper response from the server.
  Future requestHandler(String route, String method, Map data) async {
    /// Request Handler.
    ///
    /// route: [String] -> Route to be called which endpoint.
    /// method: [String] -> Method to be used which method we will use to send request.
    /// data: [Map] -> Data to be sent allmost to body.
    /// With this method we can send our route and send method as request to API,
    /// also we can send some data if we need to that.

    Response response = await dio.request(
      "$route",
      data: data,
      options: Options(
        method: method,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": true,
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        },
      ),
    );

    return response.data;
  }
}
