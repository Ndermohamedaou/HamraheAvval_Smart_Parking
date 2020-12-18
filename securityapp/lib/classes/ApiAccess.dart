import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:securityapp/constFile/ConstFile.dart';

class ApiAccess {
  // Getting instance of Dio for relation between client and server
  Dio dio = Dio();

  Future<Map> gettingUsersInfo(uToken) async {
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${uToken}";
    // Get User info with Map Type
    Response response = await dio.get("${apiUrl}/userInfo");
    return response.data;
  }

  Future<bool> updateUserInfo(avatar, uToken, email, pass) async {
    // if user does not choice any avatar for profile
    if (avatar == null) {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer ${uToken}";
      Response response = await dio
          .post("${apiUrl}/UpdateInfo?&email=${email}&password=${pass}");
      if (response.data['status'] == "200")
        return true;
      else
        return false;
    } else {
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['authorization'] = "Bearer ${uToken}";
      Response response = await dio.post(
          "${apiUrl}/UpdateInfo?&email=${email}&password=${pass}",
          data: avatar);
      if (response.data['status'] == "200") {
        return true;
      } else
        return false;
    }
  }


  Future<List> getBuilding(uToken) async{
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer ${uToken}";
    Response response = await dio.get("${apiUrl}/getBuildings");
    return response.data;
  }

  Future<Map> parkedCarsInfo({uToken, sType, plates, slotNum}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer ${uToken}";
    Response response;
    if (sType == "plate") {
      response = await dio.post(
          "${apiUrl}/searchSlot?type=${sType}&plate0=${plates[0]}&plate1=${plates[1]}&plate2=${plates[2]}&plate3=${plates[3]}");
      return response.data[0];
    } else if (sType == "slot") {
      response =
          await dio.post("${apiUrl}/searchSlot?type=${sType}&slot=${slotNum}");
      return response.data;
    }
  }

  Future<bool> sendingCarImg({uToken, plate}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer ${uToken}";
    Response response = await dio.post("${apiUrl}/uploadPlate", data: plate);
    final status = response.data['status'];

    bool successSend = false;
    print(status);
    if (status != null)
      successSend = true;
    else
      successSend = false;

    return successSend;
  }
// TODO setting Building
  Future<List> getSlots({String uAuth}) async {
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['authorization'] = "Bearer ${uAuth}";
    Response response = await dio.get("${apiUrl}/getSlots");
    return response.data;
  }

}
