import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';

class InitReserve {
  ApiAccess api = ApiAccess();
  Future<List> initializeReserve() async {
    FlutterSecureStorage lds = FlutterSecureStorage();
    final uToken = await lds.read(key: "token");
    // print(userToken);
    try {
      return await api.userReserveHistory(token: uToken);
    } catch (e) {
      return [];
    }
  }
}
