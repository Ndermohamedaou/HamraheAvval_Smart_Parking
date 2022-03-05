import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FlutterMediaPicker {
  final ImagePicker _picker = ImagePicker();
  Future<File> pickImage({ImageSource source}) async {
    ///
    /// Pick image as global part of the app and use it any where.
    /// Main method and use it from one source can be gallery or camera
    /// image pick source type.
    final image =
        await this._picker.pickImage(source: source, imageQuality: 50);
    return File(image.path);
  }
}
