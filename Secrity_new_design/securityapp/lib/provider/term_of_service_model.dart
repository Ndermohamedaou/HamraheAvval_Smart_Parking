import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:securityapp/model/ApiAccess.dart';
import 'package:securityapp/spec/FlowState.dart';

class TermsOfServiceModel with ChangeNotifier {
  FlowState _termsLoadStatus = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  var termsOfService = "";

  TermsOfServiceModel() {
    _getTerms();
  }

  FlowState get termsStatus => _termsLoadStatus;
  Future get fetchTerms => _getTerms();

  Future<void> _getTerms() async {
    final userToken = await lStorage.read(key: "token");
    ApiAccess api = ApiAccess();
    _termsLoadStatus = FlowState.Loading;
    try {
      final termsResult = await api.getTerms(userToken);
      termsOfService = termsResult;
      // print(termsOfService);

      _termsLoadStatus = FlowState.Loaded;
    } catch (e) {
      print("Error in terms of service model $e");
      _termsLoadStatus = FlowState.Error;
    }

    notifyListeners();
  }
}
