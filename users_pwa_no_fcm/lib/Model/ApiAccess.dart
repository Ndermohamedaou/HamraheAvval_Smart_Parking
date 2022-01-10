import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:dio/dio.dart';

class ApiAccess {
  Dio dio = Dio();

  Future<Map> getAccessToLogin({email, password, deviceToken}) async {
    Response res = await dio.post(
        "$baseUrl/login?personal_code=$email&password=$password&DeviceToken=$deviceToken");
    return res.data;
  }

  Future<String> logout({String token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response res = await dio.post("$baseUrl/logout");
    return res.data;
  }

  Future<Map> submitOTPCode({code, persCode, devToken}) async {
    Response res = await dio.post(
        "$baseUrl/submitCode?code=$code&personal_code=$persCode&DeviceToken=$devToken");
    return res.data;
  }

  Future<String> resendsubmitOTPCode({persCode}) async {
    Response res = await dio.post("$baseUrl/resendOTP?personal_code=$persCode");
    return res.data;
  }

  // Reset password for forget password
  Future<String> submitOTPPasswordReset({personalCode}) async {
    Response res =
        await dio.post("$baseUrl/PasswordReset?personal_code=$personalCode");
    return res.data;
  }

  Future<String> recoverUserPassword({otpCode, password}) async {
    Response res = await dio
        .post("$baseUrl/recover_password?otp_code=$otpCode&password=$password");
    return res.data;
  }

  Future<Map> getStaffInfo({token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.get("$baseUrl/staffInfo");
    return response.data;
  }

  Future<String> updateStaffInfoInConfrimation(
      {token, avatar, curPass, newPass}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post("$baseUrl/updateStaffInfo", data: {
      "avatar": avatar,
      "current_password": curPass,
      "new_password": newPass
    });
    return response.data['status'];
  }

  Future<String> modifyUserEmail({token, email}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response =
        await dio.post("$baseUrl/updateStaffInfo", data: {"email": email});
    return response.data['status'];
  }

  // Future<String> getUserAvatar({token}) async {
  //   dio.options.headers['Content-Type'] = 'application/json';
  //   dio.options.headers["Authorization"] = "Bearer $token";
  //   Response response = await dio.get("$baseUrl/staffInfo");
  //   return response.data['avatar'];
  // }

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
    // print(response.data);
    return response.data;
  }

  // Info For adding plate by documents
  // car_card_image
  // melli_card_image
  // melli_card_owner
  Future<String> addSelfPlate(
      {token, lsPlate, selfMelliCard, selfCarCard}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";

    Response response = await dio.post(
        "$baseUrl/uploadDocuments?type=self&plate0=${lsPlate[0]}&plate1=${lsPlate[1]}&plate2=${lsPlate[2]}&plate3=${lsPlate[3]}",
        data: {
          "melli_card_image": selfMelliCard,
          "car_card_image": selfCarCard,
        });
    // print(response.data);
    return response.data;
  }

  Future<String> addFamilyPlate(
      {token, lsPlate, selfMelliCard, ownerCarCard, ownerMelliCard}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";

    Response response = await dio.post(
        "$baseUrl/uploadDocuments?type=family&plate0=${lsPlate[0]}&plate1=${lsPlate[1]}&plate2=${lsPlate[2]}&plate3=${lsPlate[3]}",
        data: {
          "melli_card_image": selfMelliCard,
          "melli_card_owner": ownerMelliCard,
          "car_card_image": ownerCarCard,
        });
    // print(response.data);
    return response.data;
  }

  Future<String> addOtherPlate({token, lsPlate}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";

    Response response = await dio.post(
        "$baseUrl/uploadDocuments?type=other&plate0=${lsPlate[0]}&plate1=${lsPlate[1]}&plate2=${lsPlate[2]}&plate3=${lsPlate[3]}");
    // print(response.data);
    return response.data;
  }

  Future<String> delUserPlate({token, id}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post("$baseUrl/delUserPlate?plate_en=$id");
    // print(response.data);
    return response.data;
  }

  Future<String> reserveByUser({token, List days}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response =
        await dio.post("$baseUrl/Reserve", data: {"reserve_dates": days});
    return response.data;
  }

  Future<List> reserveWeeks({token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.get("$baseUrl/getReserveWeeks");
    return response.data;
  }

  Future<List> userReservesByWeeks({token, String startWeekDate}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response =
        await dio.post("$baseUrl/getUserReservesByWeek?week=$startWeekDate");
    return response.data;
  }

  Future<Map> checkPlateExistence({token, List plate}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post(
        "$baseUrl/checkPlateExistence?plate0=${plate[0]}&plate1=${plate[1]}&plate2=${plate[2]}&plate3=${plate[3]}");
    return response.data;
  }

  Future<String> updatingUserAvatar({token, uAvatar}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response =
        await dio.post("$baseUrl/updateStaffInfo", data: {"avatar": uAvatar});
    return response.data['status'];
  }

  Future<dynamic> userReserveHistory({token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.get("$baseUrl/getUserReserves");
    return response.data;
  }

  Future<String> changingUserPassword({token, curPass, newPass}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post(
        "$baseUrl/changePassword?current_password=$curPass&new_password=$newPass");
    // print("From API CLASS $response.data");
    return response.data;
  }

  Future<String> cancelingReserve({token, reservID}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response = await dio.post("$baseUrl/cancelReserve?id=$reservID");
    // print("From API CLASS $response.data");
    return response.data;
  }

  Future<String> performInstantReserve({token, plate}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response response =
        await dio.post("$baseUrl/InstantReserve?plate_en=$plate");
    // print("From API CLASS $response.data");
    return response.data;
  }
}
