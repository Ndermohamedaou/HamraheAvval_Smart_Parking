import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/Model/endpoints.dart';

class AddPlateProc {
  Future<int> uploadDocument(
      {token, String type, PlateStructure plate, data}) async {
    /// Upload user plate document to server.
    ApiAccess api = new ApiAccess(token);
    try {
      Endpoint uploadDocumentEndpoint =
          apiEndpointsMap["plateEndpoint"]["uploadDocuments"];
      // Getting data from request handler
      final result = await api.requestHandler(
          "${uploadDocumentEndpoint.route}?type=$type&plate0=${plate.plate0}&plate1=${plate.plate1}&plate2=${plate.plate2}&plate3=${plate.plate3}",
          uploadDocumentEndpoint.method,
          data);

      print(result);

      switch (result) {
        case "200":
          return 200;
          break;
        case "InPersonVisit":
          return 200;
          break;
        case "MaxPlateCount":
          return 100;
        case "PlateExists":
          return 1;
        default:
      }
    } catch (e) {
      print("Erorr from addingaddUserPlat mine plate $e");
      return -1;
    }
    return -1;
  }
}
