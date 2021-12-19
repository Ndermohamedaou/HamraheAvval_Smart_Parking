import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:image/image.dart' as imgEdit;

ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

class ImageConvetion {
  Future<dynamic> checkSize(File img) async {
    final imgSizeInput = (await img.readAsBytes()).lengthInBytes / 1000000;
    // print("Image size $imgSizeInput");
    // If user selected avatar is larger than 2MB
    // Convret it to small size and getting base64 image String
    print(imgSizeInput > 2.0);

    if (imgSizeInput > 2.0) {
      imgEdit.Image imageSrc = imgEdit.decodeImage(img.readAsBytesSync());
      imgEdit.Image cropedImageSrc =
          imgEdit.copyResizeCropSquare(imageSrc, 512);
      final setMediumQuality = imgEdit.encodeJpg(cropedImageSrc, quality: 50);
      return img2Base64(setMediumQuality);
    } else {
      imgEdit.Image imageSrc = imgEdit.decodeImage(img.readAsBytesSync());
      imgEdit.Image cropedImageSrc =
          imgEdit.copyResizeCropSquare(imageSrc, 512);
      final editedAvatar = imgEdit.encodeJpg(cropedImageSrc);
      return img2Base64(editedAvatar);
    }
  }

  Future<String> img2Base64(imgByte) async {
    try {
      if (imgByte != null) {
        // final byteImg = img.readAsBytesSync();
        String _img64 = base64Encode(imgByte);
        return _img64;
      } else
        return "";
    } catch (e) {
      return "";
    }
  }

  Future<String> sendingImage(File img) async {
    final uToken = await lds.read(key: "token");
    String imgConverted = await checkSize(img);
    // print("Conversion image TO -----> \n $imgConverted");
    String takenSuccessful =
        await api.updatingUserAvatar(token: uToken, uAvatar: imgConverted);
    // print(takenSuccessful);
    return takenSuccessful;
  }
}
