import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:image/image.dart' as imgEdit;
import 'package:payausers/Model/endpoints.dart';

FlutterSecureStorage lds = FlutterSecureStorage();

class ImageConvetion {
  bool imgSizeChecker(File img) {
    /// Checking image size in MB.
    ///
    /// We need check image size if had more than 1 MB, we will show error to user.
    final imgSize = (img.readAsBytesSync()).lengthInBytes / 1000000;
    return imgSize > 2.0 ? false : true;
  }

  Future<String> checkSize(File img) async {
    try {
      // Read image as bytes. preparing for generate base64 format string.
      imgEdit.Image imageSrc = imgEdit.decodeImage(img.readAsBytesSync());
      // Crop image
      // imgEdit.Image cropedImageSrc =
      //     imgEdit.copyResizeCropSquare(imageSrc, imageSrc.width);

      // Check image is more than 2 MB set quality to 50% else set quality to 100%.
      final editedAvatar =
          imgEdit.encodeJpg(imageSrc, quality: !imgSizeChecker(img) ? 50 : 100);
      // Convert final image to base64 format string.
      return img2Base64(editedAvatar);
    } catch (e) {
      return "";
    }
  }

  Future<String> img2Base64(imgByte) async {
    try {
      if (imgByte != null) {
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
    ApiAccess api = ApiAccess(uToken);
    String imgConverted = await checkSize(img);
    // print("Conversion image TO -----> \n $imgConverted");
    Endpoint updateStaffInfoEndpoint =
        apiEndpointsMap["auth"]["updateStaffInfo"];

    final response = await api.requestHandler(
        updateStaffInfoEndpoint.route, updateStaffInfoEndpoint.method, {
      "avatar": imgConverted,
    });
    return response["status"];
  }
}
