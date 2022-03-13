import 'package:securityapp/model/ApiAccess.dart';

class ImgProcessing {
  ApiAccess api = ApiAccess();
  Future<Map> sendingImage({token, img, state}) async {
    print(img);
    return await api.submittingCarPlate(
        uToken: token, plate: img, cameraState: state);
  }
}
