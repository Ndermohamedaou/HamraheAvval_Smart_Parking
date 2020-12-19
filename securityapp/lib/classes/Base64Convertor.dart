import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class Base64Convertor {
  Widget dataFromBase64String(String base64String, BoxFit fitMode) {
    try {
      if (base64String.length % 4 == 3)
        base64String += "=";
      else if (base64String.length % 4 == 2) base64String += "==";

      return Image.memory(base64.decode(base64String), fit: fitMode);
    } catch (e) {
      return Image.asset(
        "assets/images/samplePlateImg.jpg",
        fit: BoxFit.cover,
      );
    }
  }
}
