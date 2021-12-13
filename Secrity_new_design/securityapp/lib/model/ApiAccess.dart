import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:securityapp/constFile/initVar.dart';

class ApiAccess {
  // Getting instance of Dio for relation between client and server
  Dio dio = Dio();

  Future<Map<String, dynamic>> login({personalCode, password}) async {
    Response res = await dio
        .post("$baseURL/login?personal_code=$personalCode&password=$password");
    return res.data;
  }

  Future<String> logout({String token}) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    Response res = await dio.post("$baseURL/logout");
    return res.data;
  }

  Future<Map> gettingUsersInfo(uToken) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer $uToken";
    // Get User info with Map Type
    Response response = await dio.get("$baseURL/userInfo");
    return response.data;
  }

  // If first visit be true
  Future<bool> updateUserInfo({avatar, uToken, email, pass}) async {
    // if user does not choice any avatar for profile
    if (avatar == null) {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer $uToken";
      Response response = await dio.post("$baseURL/UpdateInfo",
          data: {"avatar": avatar, "email": email, "password": pass});
      if (response.data['status'] == "200")
        return true;
      else
        return false;
    } else {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer $uToken";
      Response response = await dio.post("$baseURL/UpdateInfo",
          data: {"avatar": avatar, "email": email, "password": pass});
      if (response.data['status'] == "200") {
        return true;
      } else
        return false;
    }
  }

  Future<bool> updateAvatar({uToken, uAvatar}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";
    Response res =
        await dio.post("$baseURL/UpdateInfo", data: {"avatar": uAvatar});
    if (res.data['status'] == "200")
      return true;
    else
      return false;
  }

  Future<List> getBuilding(uToken) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";
    Response response = await dio.get("$baseURL/getBuildings");
    return response.data;
  }

  // Searching by Plate
  Future<List> searchingByPlate({uToken, List plates}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";

    Response res = await dio.post(
        "$baseURL/searchSlot?type=plate&plate0=${plates[0]}&plate1=${plates[1]}&plate2=${plates[2]}&plate3=${plates[3]}");
    return res.data;
  }

  // Searching by Slot
  Future<Map> searchingBySlot({uToken, slotNum, buildingName}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";
    // print("searchSlot?type=slot&slot=$buildingName-$slotNum");
    Response res = await dio.post(
        "$baseURL/searchSlot?type=slot&slot=$slotNum&building=$buildingName");
    return res.data;
  }

  // Searching by Personal Code
  Future<Map> searchingByPersonalCode({uToken, persCode}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";

    Response res = await dio
        .post("$baseURL/searchSlot?type=personal_code&personal_code=$persCode");
    return res.data;
  }

  // Searching by Captured Image from Sec man
  Future<Map> searchingByImage({uToken, img}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";

    Response res = await dio.post("$baseURL/searchSlot?type=plate_image",
        data: {"plate_image": img});
    return res.data;
  }

  Future<Map> sendingCarImg({uToken, plate}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";
    Response response = await dio.post("$baseURL/uploadPlate", data: plate);

    return response.data;
  }

  Future<Map> submittingCarPlate({uToken, plate, cameraState}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uToken";
    Response response = await dio.post("$baseURL/uploadPlate?plate",
        data: {"plate": plate, "cameraState": cameraState});
    // In this section we want get Map form data
    // but server String base Json in Client
    // So, i decode json form to usual Map data
    Map realS = jsonDecode(response.data);
    print(realS);
    // print(realS['plate_fa0']);
    return realS;
  }

  Future<Map> getSlots({String uAuth, String slotName}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer $uAuth";
    Response response = await dio.get("$baseURL/getSlots/$slotName");
    return response.data;
  }
}
