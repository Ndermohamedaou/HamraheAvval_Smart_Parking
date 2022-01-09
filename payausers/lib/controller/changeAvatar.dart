import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:image/image.dart' as imgEdit;

ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

class ImageConvetion {
  Future<String> checkSize(File img) async {
    // Read image as bytes. preparing for generate base64 format string.
    imgEdit.Image imageSrc = imgEdit.decodeImage(img.readAsBytesSync());
    // Crop image
    // imgEdit.Image cropedImageSrc =
    //     imgEdit.copyResizeCropSquare(imageSrc, imageSrc.width);
    final editedAvatar = imgEdit.encodeJpg(imageSrc);
    return img2Base64(editedAvatar);
  }

  bool imgSizeChecker(File img) {
    /// Checking image size in MB.
    ///
    /// We need check image size if had more than 1 MB, we will show error to user.
    final imgSize = (img.readAsBytesSync()).lengthInBytes / 1000000;
    print(imgSize);
    return imgSize > 1.0 ? false : true;
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
