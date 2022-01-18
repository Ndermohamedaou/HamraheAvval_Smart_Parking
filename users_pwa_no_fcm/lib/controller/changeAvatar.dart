import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/Model/imageConvertor.dart';
import 'package:shared_preferences/shared_preferences.dart';

ImgConversion convertable = ImgConversion();
Future<String> sendingImage(img) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final uToken = prefs.getString("token");
  ApiAccess api = ApiAccess(uToken);
  String imgConverted = await convertable.img2Base64(img);
  Endpoint updateStaffInfoEndpoint = apiEndpointsMap["auth"]["updateStaffInfo"];

  final response = await api.requestHandler(
      updateStaffInfoEndpoint.route, updateStaffInfoEndpoint.method, {
    "avatar": imgConverted,
  });
  return response["status"];
}
