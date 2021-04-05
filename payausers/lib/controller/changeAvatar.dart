import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:image_native_resizer/image_native_resizer.dart';
import 'package:payausers/Classes/ApiAccess.dart';

ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

Future<String> img2Base64(img) async {
  try {
    if (img != null) {
      // Ready for resize image to low and middle quality
      // final reSizeImgPath = await ImageNativeResizer.resize(
      //   imagePath: img.path,
      //   maxWidth: 512,
      //   maxHeight: 512,
      //   quality: 50,
      // );
      // // Ready to convert Img uri path to Image File
      // File resizedImgFile = File(reSizeImgPath);
      // Ready to convert image file to byte code
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
