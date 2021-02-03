import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';

ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

String img2Base64(img) {
  if (img != null) {
    final byteImg = img.readAsBytesSync();
    String _img64 = base64Encode(byteImg);
    return _img64;
  } else {
    return "";
  }
}

Future<String> sendingImage(img) async {
  final uToken = await lds.read(key: "token");
  String imgConverted = img2Base64(img);
  // print("Conversion IMAGE TO -----> \n $imgConverted");
  String takenSuccessful =
      await api.updatingUserAvatar(token: uToken, uAvatar: imgConverted);
  // print(takenSuccessful);
  return takenSuccessful;
}
