import 'dart:convert';
import 'dart:typed_data';

class Base64Convertor {
  Uint8List dataFromBase64String(String base64String) {
    try {
      if (base64String.length % 4 == 3)
        base64String += "=";
      else if (base64String.length % 4 == 2) base64String += "==";

      return base64.decode(base64String);
    } catch (e) {
      return null;
    }
  }
}
