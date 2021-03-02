import 'package:securityapp/model/ApiAccess.dart';

class ImgProcessing {
  ApiAccess api = ApiAccess();
  Future<Map> sendingImage({token, img, state}) async {
    try {
      return await api.submittingCarPlate(
          uToken: token, plate: img, cameraState: state);
    } catch (e) {
      // print("READY TO SAVE !");
      return {};
    }
  }
}
