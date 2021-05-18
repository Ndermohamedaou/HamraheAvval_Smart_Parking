import 'package:payausers/Classes/ApiAccess.dart';

class InstantReserve {
  ApiAccess api = ApiAccess();

  Future<String> instantReserve({plate_en, token}) async {
    try {
      return await api.performInstantReserve(token: token, plate: plate_en);
    } catch (e) {
      print("Error from instant reserve $e");
      return "";
    }
  }
}
