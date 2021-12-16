import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/imageConvertor.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiAccess api = ApiAccess();
ImgConversion convertable = ImgConversion();
Future<String> sendingImage(img) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final uToken = prefs.getString("token");
  String imgConverted = await convertable.img2Base64(img);
  String takenSuccessful =
      await api.updatingUserAvatar(token: uToken, uAvatar: imgConverted);
  return takenSuccessful;
}
