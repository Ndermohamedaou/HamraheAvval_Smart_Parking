import 'dart:convert';

class ConvertImage {
  Future<String> img2Base64({img}) async {
    try {
      if (img != null) {
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
}
