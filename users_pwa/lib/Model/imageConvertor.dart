import 'dart:convert';

import 'package:image/image.dart' as img;

class ImgConversion {
  Future<String> img2Base64(byteImg) async {
    try {
      if (byteImg != null) {
        img.Image image = img.decodeImage(byteImg);
        // Crop our image to a square
        // img.Image resized = img.copyResizeCropSquare(image, 512);
        final properByteImg = img.encodeJpg(image, quality: 50);
        String _img64 = base64Encode(properByteImg);
        return _img64;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }
}
