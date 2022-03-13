import 'package:securityapp/model/ApiAccess.dart';

class ImgProcessing {
  ApiAccess api = ApiAccess();
  Future<Map> sendingImage({token, img, state, buildingName}) async {
    print(img);
    return await api.submittingCarPlate(
        uToken: token,
        plate: img,
        cameraState: state,
        buildingName: buildingName);
  }
}
