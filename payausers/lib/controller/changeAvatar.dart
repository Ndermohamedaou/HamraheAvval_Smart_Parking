import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:image_native_resizer/image_native_resizer.dart';
import 'package:payausers/Model/ApiAccess.dart';

ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

class ImageConvetion {
  Future<String> img2Base64(img) async {
    try {
      if (img != null) {
        final byteImg = img.readAsBytesSync();
        String _img64 = base64Encode(byteImg);

        return _img64;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<String> sendingImage(img) async {
    final uToken = await lds.read(key: "token");
    String imgConverted = await img2Base64(img);
    // print("Conversion IMAGE TO -----> \n $imgConverted");
    String takenSuccessful =
        await api.updatingUserAvatar(token: uToken, uAvatar: imgConverted);
    // print(takenSuccessful);
    return takenSuccessful;
  }
}
