import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';

class InstantReserve {
  Future<String> instantReserve({token}) async {
    Endpoint instantReserveEndpoint =
        apiEndpointsMap["reserveEndpoint"]["InstantReserve"];
    ApiAccess api = ApiAccess(token);

    try {
      return await api.requestHandler(
          "${instantReserveEndpoint.route}", instantReserveEndpoint.method, {});
    } catch (e) {
      print("Error from instant reserve $e");
      return "";
    }
  }
}
