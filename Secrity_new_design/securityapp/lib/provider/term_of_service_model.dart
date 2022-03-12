import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:securityapp/spec/FlowState.dart';

class TermsOfServiceModel with ChangeNotifier {
  FlowState _termsLoadStatus = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  var termsOfService = "";

  TermsOfServiceModel() {}

  Future<void> _getTerms() async {
    final userToken = await lStorage.read(key: "token");
  }
}
