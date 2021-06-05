import 'package:payausers/Model/ApiAccess.dart';

class InstantReserve {
  ApiAccess api = ApiAccess();

  Future<String> instantReserve({token}) async {
    try {
      return await api.performInstantReserve(token: token);
    } catch (e) {
      print("Error from instant reserve $e");
      return "";
    }
  }
}
